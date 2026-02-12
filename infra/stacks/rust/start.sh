#!/bin/bash
set -e

echo "Checking disk space..."
df -h

# Update and validate the server files
# app_id 258550 is Rust
# Using a retry loop because steamcmd can be flaky (0x6 errors)
MAX_RETRIES=5
RETRY_DELAY=10

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Update attempt $i of $MAX_RETRIES..."
    # We use 'set +e' temporarily to handle the potential failure manually, 
    # though usage in 'if' should prevent immediate exit with 'set -e'
    if steamcmd +force_install_dir /steamcmd/rust/game +login anonymous +app_update 258550 validate +quit; then
        echo "Rust server update successful!"
        break
    else
        echo "SteamCMD update failed."
        if [ $i -lt $MAX_RETRIES ]; then
            echo "Retrying in $RETRY_DELAY seconds..."
            sleep $RETRY_DELAY
        else
            echo "Failed to update Rust server after $MAX_RETRIES attempts."
            exit 1
        fi
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
