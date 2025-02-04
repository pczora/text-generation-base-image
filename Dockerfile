ARG CUDA_VERSION="12.1.1"
ARG CUDNN_VERSION="8"
ARG UBUNTU_VERSION="22.04"
ARG DOCKER_FROM=nvidia/cuda:$CUDA_VERSION-cudnn$CUDNN_VERSION-devel-ubuntu$UBUNTU_VERSION
ARG CUDA="121"
# Base NVidia CUDA Ubuntu image
FROM --platform=amd64 $DOCKER_FROM AS base

ARG TEXT_GENERATION_WEBUI_REPO_URL="https://github.com/oobabooga/text-generation-webui.git"
ARG TEXT_GENERATION_WEBUI_REF="v1.13"

# Install Python plus openssh, which is our minimum set of required packages.
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv && \
    apt-get install -y --no-install-recommends openssh-server openssh-client git git-lfs espeak-ng curl unzip && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/cuda/bin:${PATH}"

SHELL ["/bin/bash", "-c"]
WORKDIR /root

# Install text-generation-webui, including all extensions
# Also includes exllama
# We remove the ExLlama automatically installed by text-generation-webui
# so we're always up-to-date with any ExLlama changes, which will auto compile its own extension
RUN git clone $TEXT_GENERATION_WEBUI_REPO_URL && \
    cd text-generation-webui && \
    # checkout a specific commit to avoid breaking changes in the future
    git checkout $TEXT_GENERATION_WEBUI_REF && \
    python3 -m venv /text-generation-webui-env && \
    source /text-generation-webui-env/bin/activate && \
    pip3 install --no-cache-dir -U torch==2.2.2 torchvision torchaudio wheel setuptools pyyaml --extra-index-url https://download.pytorch.org/whl/cu$CUDA && \
    pip3 install -r requirements.txt && \
    bash -c 'for req in extensions/*/requirements.txt ; do pip3 install -r "$req" ; done' && \
    mkdir -p repositories && \
    cd repositories && \
    git clone https://github.com/turboderp/exllama && \
    sed 's/safetensors==0.3.2/safetensors==0.4.3/g' exllama/requirements.txt && \
    pip3 install -r exllama/requirements.txt && \
    pip3 install --upgrade safetensors==0.4.3 && \
    pip3 install --upgrade --no-deps exllamav2 && \
    pip3 install --upgrade fastapi==0.111.0 && \
    deactivate
COPY --chmod=755 scripts ./scripts

WORKDIR /
COPY --chmod=755 start-with-ui.sh /start-with-ui.sh

CMD [ "/start-with-ui.sh" ]