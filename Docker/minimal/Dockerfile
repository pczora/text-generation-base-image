FROM ubuntu:24.04

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw \
    apt update && \
    apt install --no-install-recommends -y git vim build-essential python3 python3-dev pip bash curl && \
    rm -rf /var/lib/apt/lists/*
# Clone repository
RUN git clone https://github.com/oobabooga/text-generation-webui && \
    cd text-generation-webui && \
    python3 -m venv venv && \
    source venv/bin/activate

RUN pip3 install -r requirements/portable/requirements.txt
RUN pip3 install autoawq
EXPOSE ${CONTAINER_PORT:-7860} ${CONTAINER_API_PORT:-5000} ${CONTAINER_API_STREAM_PORT:-5005}
# Launch server (basic command)
CMD python3 server.py --portable --api --auto-launch


