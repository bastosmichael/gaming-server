#!/bin/bash
set -e

INSTALL_DIR="/steamcmd/rust/game"
APP_ID="258550"

echo "Checking disk space..."
df -h

# Update and validate the server files
# app_id 258550 is Rust
# Clear partial SteamCMD state between retries to recover from stuck manifests.
RETRY_DELAY=10
MAX_DELAY=300 # Cap delay at 5 minutes
attempt=1

reset_steamcmd_state() {
    echo "Resetting SteamCMD state for app ${APP_ID}..."
    rm -f "${INSTALL_DIR}/steamapps/appmanifest_${APP_ID}.acf"
    rm -rf "${INSTALL_DIR}/steamapps/downloading/${APP_ID}"
    rm -rf "${INSTALL_DIR}/steamapps/temp"
}

while true; do
    echo "Update attempt $attempt..."
    if steamcmd +force_install_dir "${INSTALL_DIR}" +login anonymous +app_update "${APP_ID}" validate +quit; then
        echo "Rust server update successful!"
        break
    else
        reset_steamcmd_state
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
cd "${INSTALL_DIR}"
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
