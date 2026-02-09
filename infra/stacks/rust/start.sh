#!/bin/bash
set -e

echo "Cleaning bundles to ensure integrity..."
rm -rf /steamcmd/rust/game/Bundles
rm -rf /steamcmd/rust/game/bundles

echo "Updating Rust server..."
# Update and validate the server files
# app_id 258550 is Rust
steamcmd +force_install_dir /steamcmd/rust/game +login anonymous +app_update 258550 validate +quit

echo "Starting Rust server..."
# Default environment variables
: ${RUST_SERVER_IDENTITY:="docker"}
: ${RUST_SERVER_SEED:="1337"}
: ${RUST_SERVER_WORLDSIZE:="3000"}
: ${RUST_SERVER_NAME:="Rust Server"}
: ${RUST_SERVER_MAXPLAYERS:="10"}
: ${RUST_RCON_PORT:="28016"}
: ${RUST_RCON_PASSWORD:="docker"}
: ${RUST_SERVER_PORT:="28015"}

# Construct startup arguments
# Note: +server.secure 1 is default
exec ./game/RustDedicated \
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
  $RUST_SERVER_STARTUP_ARGUMENTS
