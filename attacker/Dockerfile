FROM alpine:3.19

# Install base tools with no-cache and cleanup
RUN apk add --no-cache --update \
    curl \
    nmap \
    python3 \
    py3-pip \
    && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community \
    nikto \
    hydra \
    && rm -rf /var/cache/apk/*

# Install build tools temporarily
RUN apk add --no-cache --virtual .build-deps \
    git \
    make \
    gcc \
    musl-dev

# Install siege 4.1.4 from source
RUN wget https://download.joedog.org/siege/siege-4.1.4.tar.gz \
    && tar -xzf siege-*.tar.gz \
    && cd siege-* \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm siege-*.tar.gz \
    && rm -rf siege-*

# Install hey
RUN wget https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 -O /usr/local/bin/hey \
    && chmod +x /usr/local/bin/hey

# Install SQLMap in virtual environment
RUN python3 -m venv /opt/sqlmap-venv \
    && /opt/sqlmap-venv/bin/pip install --no-cache-dir sqlmap \
    && ln -s /opt/sqlmap-venv/bin/sqlmap /usr/local/bin/sqlmap

# Clean build dependencies
RUN apk del .build-deps

# Add attack scripts
RUN mkdir -p /scripts
COPY attack_scripts/* /scripts/
RUN chmod +x /scripts/*.sh

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD pgrep -f attack_scripts || exit 1

WORKDIR /scripts

ENV TARGET_HOST=frontend \
    TARGET_PORT=80 \
    BASE_PATH=""

CMD ["./start_attacks.sh"]
