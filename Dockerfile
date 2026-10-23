FROM python:3.11-slim

# curl is required by cfnb's bandwidth test (subprocess call)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --no-cache-dir requests aiohttp brotlicffi

COPY main.py config.json git_sync.sh health_server.py /app/

# git_sync.sh is invoked by main.py to push ip.txt; token/username/repo come
# from build args or env at runtime (script reads hardcoded vars, so we
# rewrite them at container start via entrypoint).
RUN chmod +x /app/git_sync.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Koyeb requires the container to listen on a port for health checks
ENV PORT=8000
EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
