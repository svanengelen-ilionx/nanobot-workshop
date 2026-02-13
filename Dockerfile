FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

LABEL maintainer="Ilionx Workshop"
LABEL description="NanoBot workshop image for OpenShift Dev Spaces"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        git \
        vim \
        nano \
        jq \
        procps \
        bash-completion \
        && \
    # Install Node.js 20 (needed for WhatsApp bridge)
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get purge -y gnupg && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone and install nanobot
RUN git clone --depth 1 https://github.com/HKUDS/nanobot.git /app/nanobot-src && \
    cd /app/nanobot-src && \
    uv pip install --system --no-cache -e . && \
    cd /app/nanobot-src/bridge && \
    npm install && npm run build && \
    cd /app

# Create nanobot config & workspace directories
RUN mkdir -p /root/.nanobot

# Run onboard to initialize defaults
RUN nanobot onboard

# Copy workshop materials into the image
COPY exercises/ /app/exercises/
COPY scripts/ /app/scripts/
COPY config-template.json /app/config-template.json
COPY README.md /app/README.md

# Make scripts executable
RUN chmod +x /app/scripts/*.sh 2>/dev/null || true

# Gateway default port
EXPOSE 18790

# Default to bash for interactive Dev Spaces usage
CMD ["sleep", "infinity"]
