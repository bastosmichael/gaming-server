#!/bin/bash
# Script to force update and validate Rust server files
SERVER_IP="michael@192.168.86.42"
CONTAINER_NAME="rust-server"

echo "Connecting to $SERVER_IP..."

ssh -t $SERVER_IP "
  echo 'Checking for container $CONTAINER_NAME...'
  if ! sudo docker ps -a | grep -q $CONTAINER_NAME; then
    echo 'Container $CONTAINER_NAME not found.'
    exit 1
  fi

  echo 'Stopping $CONTAINER_NAME...'
  sudo docker stop $CONTAINER_NAME

  # Find the volume mapped to /steamcmd/rust
  VOL_NAME=\$(sudo docker inspect -f '{{ range .Mounts }}{{ if eq .Destination \"/steamcmd/rust\" }}{{ .Name }}{{ end }}{{ end }}' $CONTAINER_NAME)
  
  if [ -z \"\$VOL_NAME\" ]; then
    echo 'Error: Could not determine data volume for $CONTAINER_NAME'
    exit 1
  fi

  echo \"Found volume: \$VOL_NAME\"
  echo 'Starting temporary updater container...'
  
  # Run steamcmd update with validate
  # Note: logic assumes the image has steamcmd in path or accessible. 
  # didstopia/rust-server entrypoint handles updates, but we want manual control.
  # We use standard steamcmd image or the rust-server image with custom command.
  
  sudo docker run --rm -v \$VOL_NAME:/steamcmd/rust didstopia/rust-server:latest \
    /steamcmd/steamcmd.sh +login anonymous +force_install_dir /steamcmd/rust +app_update 258550 validate +quit

  echo 'Update complete. Restarting server...'
  sudo docker start $CONTAINER_NAME
  echo 'Server restarted. Check logs with: ssh $SERVER_IP \"sudo docker logs -f $CONTAINER_NAME\"'
"
