FROM steamcmd/steamcmd:latest

# Install dependencies for Rust server
USER root
RUN apt-get update && apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    libsqlite3-0 \
    libsdl2-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create directory for Rust server
RUN mkdir -p /steamcmd/rust
WORKDIR /steamcmd/rust

# Expose ports
EXPOSE 28015/udp \
       28015/tcp \
       28016/tcp \
       28016/udp

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
