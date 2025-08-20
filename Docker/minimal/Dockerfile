FROM ubuntu:24.04
# Clone repository
RUN git clone https://github.com/oobabooga/text-generation-webui && \
    cd text-generation-webui && \
    python -m venv venv && \
    source venv/bin/activate

RUN pip install -r requirements/portable/requirements.txt
EXPOSE ${CONTAINER_PORT:-7860} ${CONTAINER_API_PORT:-5000} ${CONTAINER_API_STREAM_PORT:-5005}
# Launch server (basic command)
CMD python server.py --portable --api --auto-launch


