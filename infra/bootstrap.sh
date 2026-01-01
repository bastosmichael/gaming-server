#!/bin/bash
HOST="192.168.86.33"
USER="michael"

echo "Bootstrapping Docker on $USER@$HOST..."
ssh $USER@$HOST "
  # Fix the broken apt state from previous failed runs
  sudo rm -f /etc/apt/sources.list.d/docker.list
  
  # Install Docker using the official convenience script
  curl -fsSL https://get.docker.com | sh
  
  # Allow current user to run docker
  sudo usermod -aG docker \$USER
"

echo "Done! You can now run terraform."
