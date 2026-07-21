FROM ubuntu:24.04

ENV CUDA_HOME=/usr/local/cuda

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw \
    apt update && \
    apt install --no-install-recommends -y git vim build-essential python3.12 python3.12-dev python3.12-venv pip bash curl dkms cmake && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
RUN git clone --depth 1 --branch v4.9 https://github.com/oobabooga/text-generation-webui && \
    cd text-generation-webui && \
    python3 -m venv venv
WORKDIR text-generation-webui
RUN --mount=type=cache,target=/root/.cache/pip \
    source venv/bin/activate && \
    pip3 install torch torchvision --extra-index-url https://download.pytorch.org/whl/cu130
RUN --mount=type=cache,target=/root/.cache/pip \
    source venv/bin/activate && \
    grep -v xformers requirements/full/requirements.txt | pip3 install -r /dev/stdin && \
    pip3 install gptqmodel
RUN --mount=type=cache,target=/root/.cache/pip \
    source venv/bin/activate && \
    pip3 install https://github.com/oobabooga/llama-cpp-binaries/releases/download/v0.138.0/llama_cpp_binaries-0.138.0+cu131-py3-none-linux_x86_64.whl

EXPOSE ${CONTAINER_PORT:-7860} ${CONTAINER_API_PORT:-5000} ${CONTAINER_API_STREAM_PORT:-5005}

CMD ["/bin/bash","-lc","source venv/bin/activate && python server.py --listen --listen-host 0.0.0.0 ${UI_ARGS}"]
