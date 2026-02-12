#!/bin/bash
set -e

echo "Checking disk space..."
df -h

# Update and validate the server files
# app_id 258550 is Rust
# Using a retry loop because steamcmd can be flaky (0x6 errors)
RETRY_DELAY=10
MAX_DELAY=300 # Cap delay at 5 minutes
attempt=1

while true; do
    echo "Update attempt $attempt..."
    # We use 'set +e' temporarily to handle the potential failure manually, 
    # though usage in 'if' should prevent immediate exit with 'set -e'
    if steamcmd +force_install_dir /steamcmd/rust/game +login anonymous +app_update 258550 validate +quit; then
        echo "Rust server update successful!"
        break
    else
        echo "SteamCMD update failed. Retrying in $RETRY_DELAY seconds..."
        sleep $RETRY_DELAY

        # Exponential backoff with a cap
        RETRY_DELAY=$((RETRY_DELAY * 2))
        if [ $RETRY_DELAY -gt $MAX_DELAY ]; then
            RETRY_DELAY=$MAX_DELAY
        fi
        
        attempt=$((attempt + 1))
    fi
done

echo "Starting Rust server..."
# Default environment variables
: ${RUST_SERVER_IDENTITY:="docker"}
: ${RUST_SERVER_SEED:="1337"}
: ${RUST_SERVER_WORLDSIZE:="3000"}
: ${RUST_SERVER_NAME:="Bastos Server"}
: ${RUST_SERVER_MAXPLAYERS:="10"}
: ${RUST_RCON_PORT:="28016"}
: ${RUST_RCON_PASSWORD:="docker"}
: ${RUST_SERVER_PORT:="28015"}
: ${RUST_SERVER_PASSWORD:="evermore"}

# Construct startup arguments
# Note: +server.secure 1 is default
cd /steamcmd/rust/game
exec ./RustDedicated \
  -batchmode \
  -nographics \
  -server.ip 0.0.0.0 \
  -server.port "$RUST_SERVER_PORT" \
  -rcon.ip 0.0.0.0 \
  -rcon.port "$RUST_RCON_PORT" \
  -rcon.password "$RUST_RCON_PASSWORD" \
  -server.identity "$RUST_SERVER_IDENTITY" \
  -server.seed "$RUST_SERVER_SEED" \
  -server.worldsize "$RUST_SERVER_WORLDSIZE" \
  -server.hostname "$RUST_SERVER_NAME" \
  -server.maxplayers "$RUST_SERVER_MAXPLAYERS" \
  -server.password "$RUST_SERVER_PASSWORD" \
  $RUST_SERVER_STARTUP_ARGUMENTS
