FROM ubuntu:24.04

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw \
    apt update && \
    apt install --no-install-recommends -y git vim build-essential python3.12 python3.12-dev python3.12-venv pip bash curl bash && \
    rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-c"]
# Clone repository
RUN git clone https://github.com/oobabooga/text-generation-webui && \
    cd text-generation-webui && \
    python3 -m venv venv

WORKDIR text-generation-webui
RUN source venv/bin/activate && pip3 install -r requirements/full/requirements.txt && pip3 install autoawq
EXPOSE ${CONTAINER_PORT:-7860} ${CONTAINER_API_PORT:-5000} ${CONTAINER_API_STREAM_PORT:-5005} 5000

# Launch server (basic command)
CMD ["/bin/bash","-lc","source venv/bin/activate && python server.py --listen --listen-host 0.0.0.0"]
