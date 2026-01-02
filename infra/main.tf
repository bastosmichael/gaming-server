terraform {
  required_version = ">= 1.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}

provider "null" {}

resource "null_resource" "bootstrap_docker" {
  provisioner "local-exec" {
    command = <<EOT
      HOST="${replace(var.docker_host, "ssh://michael@", "")}"
      USER="michael"
      
      # Use system ssh to avoid terraform ssh agent issues
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" '
        # Create stack dirs
        sudo mkdir -p /opt/portainer /opt/rust-server /opt/ark /opt/cs2 /opt/minecraft /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio /opt/eco /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3 /opt/minetest /opt/openrct2 /opt/openttd /opt/zeroad /opt/openra /opt/teeworlds /opt/xonotic /opt/ioquake3 /opt/roblox
        sudo mkdir -p /opt/cs2/data
        sudo chown -R 1000:1000 /opt/cs2/data || true
      '
    EOT
  }
}

# Deploy Stacks
resource "null_resource" "deploy_stacks" {
  depends_on = [null_resource.bootstrap_docker]

  provisioner "local-exec" {
    command = <<EOT
      # Define HOST and USER
      HOST="${replace(var.docker_host, "ssh://michael@", "")}"
      USER="michael"

      # Copy Compose Files via SCP (renaming on destination to avoid collisions)
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/portainer/docker-compose.yml" "$USER@$HOST:/tmp/portainer.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/rust/docker-compose.yml" "$USER@$HOST:/tmp/rust.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/ark/docker-compose.yml" "$USER@$HOST:/tmp/ark.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/cs2/docker-compose.yml" "$USER@$HOST:/tmp/cs2.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/minecraft/docker-compose.yml" "$USER@$HOST:/tmp/minecraft.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/tf2/docker-compose.yml" "$USER@$HOST:/tmp/tf2.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/garrysmod/docker-compose.yml" "$USER@$HOST:/tmp/garrysmod.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/insurgency_sandstorm/docker-compose.yml" "$USER@$HOST:/tmp/insurgency_sandstorm.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/squad/docker-compose.yml" "$USER@$HOST:/tmp/squad.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/squad44/docker-compose.yml" "$USER@$HOST:/tmp/squad44.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/satisfactory/docker-compose.yml" "$USER@$HOST:/tmp/satisfactory.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/factorio/docker-compose.yml" "$USER@$HOST:/tmp/factorio.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/eco/docker-compose.yml" "$USER@$HOST:/tmp/eco.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/space_engineers/docker-compose.yml" "$USER@$HOST:/tmp/space_engineers.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/starbound/docker-compose.yml" "$USER@$HOST:/tmp/starbound.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/aoe2de/docker-compose.yml" "$USER@$HOST:/tmp/aoe2de.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/palworld/docker-compose.yml" "$USER@$HOST:/tmp/palworld.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/arma3/docker-compose.yml" "$USER@$HOST:/tmp/arma3.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/minetest/docker-compose.yml" "$USER@$HOST:/tmp/minetest.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/openrct2/docker-compose.yml" "$USER@$HOST:/tmp/openrct2.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/openttd/docker-compose.yml" "$USER@$HOST:/tmp/openttd.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/zeroad/docker-compose.yml" "$USER@$HOST:/tmp/zeroad.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/openra/docker-compose.yml" "$USER@$HOST:/tmp/openra.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/teeworlds/docker-compose.yml" "$USER@$HOST:/tmp/teeworlds.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/xonotic/docker-compose.yml" "$USER@$HOST:/tmp/xonotic.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/ioquake3/docker-compose.yml" "$USER@$HOST:/tmp/ioquake3.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/valheim/docker-compose.yml" "$USER@$HOST:/tmp/valheim.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/valheim_thunderstore/docker-compose.yml" "$USER@$HOST:/tmp/valheim_thunderstore.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/terraria/docker-compose.yml" "$USER@$HOST:/tmp/terraria.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/dont_starve_together/docker-compose.yml" "$USER@$HOST:/tmp/dont_starve_together.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/vintage_story/docker-compose.yml" "$USER@$HOST:/tmp/vintage_story.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/roblox/docker-compose.yml" "$USER@$HOST:/tmp/roblox.docker-compose.yml"

      # Execute Remote Setup via SSH
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'bash -s' <<'REMOTE_SCRIPT'
        set -e
        
        # Helper for retrying commands (fixes transient DNS/network issues)
        function retry {
          local retries=5
          local count=0
          until "$@"; do
            exit=$?
            wait=$((2 ** count))
            count=$((count + 1))
            if [ $count -lt $retries ]; then
              echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
              sleep $wait
            else
              echo "Retry $count/$retries exited $exit, no more retries left."
              return $exit
            fi
          done
          return 0
        }

        # Helper to validate container health before pausing
        function check_and_pause {
          local container_name=$1
          local max_wait=$${2:-60}

          # Skip pausing Portainer itself so it remains usable
          if [ "$container_name" = "portainer" ]; then
            echo "Skipping pause for Portainer."
            return 0
          fi

          echo "Waiting up to $${max_wait}s for $container_name to finish initializing..."
          local waited=0

          # Poll until the container is running or a fatal state is hit
          while [ $waited -lt $max_wait ]; do
            local status
            status=$(sudo docker inspect -f '{{.State.Status}}' "$container_name" 2>/dev/null || echo "missing")

            case "$status" in
              running)
                echo "SUCCESS: $container_name is healthy and running after $${waited}s. Pausing now to save RAM..."
                sudo docker compose pause
                return 0
                ;;
              exited|dead)
                echo "ERROR: $container_name exited before it became healthy (status: $status)."
                echo "Recent logs for $container_name:"
                sudo docker logs --tail 20 "$container_name" || true
                return 1
                ;;
              missing)
                echo "Waiting: $container_name not created yet ($${waited}s/$${max_wait}s)..."
                ;;
              *)
                echo "Waiting: $container_name status is $status ($${waited}s/$${max_wait}s)..."
                ;;
            esac

            sleep 5
            waited=$((waited + 5))
          done

          echo "ERROR: $container_name did not reach running state within $${max_wait}s."
          echo "Recent logs for $container_name:"
          sudo docker logs --tail 20 "$container_name" || true
          # We do NOT pause if it's broken, so valid logs are preserved/visible in Portainer
          return 1
        }

        # Restart DNS resolver to fix "server misbehaving" errors
        sudo systemctl restart systemd-resolved || true
        
        # Ensure directories exist (in case bootstrap didn't run or new ones matched)
        sudo mkdir -p /opt/portainer /opt/rust-server /opt/ark /opt/cs2 /opt/minecraft /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio \
          /opt/eco /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3 /opt/minetest /opt/openrct2 \
          /opt/openttd /opt/zeroad /opt/openra /opt/teeworlds /opt/xonotic /opt/ioquake3 /opt/valheim /opt/valheim-thunderstore /opt/terraria /opt/dont-starve-together /opt/vintage-story /opt/roblox
        sudo mkdir -p /opt/cs2/data
        sudo chown -R 1000:1000 /opt/cs2/data /opt/ark /opt/portainer /opt/rust-server /opt/minecraft \
          /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio /opt/eco \
          /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3 /opt/minetest /opt/openrct2 /opt/openttd \
          /opt/zeroad /opt/openra /opt/teeworlds /opt/xonotic /opt/ioquake3 /opt/valheim /opt/valheim-thunderstore /opt/terraria \
          /opt/dont-starve-together /opt/vintage-story /opt/roblox || true

        # Configure Firewall (UFW)
        echo "Configuring Firewall..."
        sudo ufw allow 22/tcp  # SSH
        sudo ufw allow 80/tcp  # HTTP (reverse proxies / direct web access)
        sudo ufw allow 443/tcp # HTTPS (reverse proxies / direct web access)
        sudo ufw allow 8000/tcp # Portainer
        sudo ufw allow 9000/tcp # Portainer
        sudo ufw allow 3100/tcp # Roblox Studio (web)
        sudo ufw allow 3101/tcp # Roblox Studio (VNC)
        sudo ufw allow 28015:28016/udp # Rust
        sudo ufw allow 28015:28016/tcp # Rust RCON
        sudo ufw allow 7777:7778/udp # Ark
        sudo ufw allow 27015/udp     # CS2 / Ark Query
        sudo ufw allow 27015/tcp     # CS2 RCON
        sudo ufw allow 25565/tcp     # Minecraft
        sudo ufw allow 27017/udp     # TF2
        sudo ufw allow 27017/tcp     # TF2 RCON
        sudo ufw allow 27008/udp     # Garry's Mod
        sudo ufw allow 27018/udp     # Garry's Mod
        sudo ufw allow 27102/udp     # Insurgency: Sandstorm
        sudo ufw allow 27131/udp     # Insurgency: Sandstorm
        sudo ufw allow 7787/udp      # Squad
        sudo ufw allow 27165/udp     # Squad
        sudo ufw allow 27165/tcp     # Squad RCON
        sudo ufw allow 10027/udp     # Squad 44
        sudo ufw allow 10037/udp     # Squad 44
        sudo ufw allow 15000/udp     # Satisfactory
        sudo ufw allow 15777/udp     # Satisfactory
        sudo ufw allow 7779/udp      # Satisfactory (Mapped)
        sudo ufw allow 34197/udp     # Factorio
        sudo ufw allow 27022/tcp     # Factorio RCON
        sudo ufw allow 3010/tcp      # Eco
        sudo ufw allow 3011/udp      # Eco
        sudo ufw allow 27019/udp     # Space Engineers
        sudo ufw allow 8766/udp      # Space Engineers
        sudo ufw allow 21025/tcp     # Starbound
        sudo ufw allow 27020:27021/udp # AoE2 DE
        sudo ufw allow 8211/udp      # Palworld
        sudo ufw allow 27023/udp     # Palworld
        sudo ufw allow 2302:2306/udp # Arma 3
        sudo ufw allow 30000/udp     # Minetest
        sudo ufw allow 11753/udp     # OpenRCT2
        sudo ufw allow 11753/tcp     # OpenRCT2
        sudo ufw allow 3979/udp      # OpenTTD
        sudo ufw allow 3979/tcp      # OpenTTD
        sudo ufw allow 20595/udp     # 0 A.D.
        sudo ufw allow 1234/udp      # OpenRA
        sudo ufw allow 1234/tcp      # OpenRA
        sudo ufw allow 8303/udp      # Teeworlds / DDNet
        sudo ufw allow 8304/udp      # DDNet Alternate Mapping
        sudo ufw allow 26000/udp     # Xonotic
        sudo ufw allow 26000/tcp     # Xonotic
        sudo ufw allow 27960/udp     # ioquake3 / Quake 3
        sudo ufw allow 2456:2458/udp # Valheim
        sudo ufw allow 7777/tcp      # Terraria / tModLoader
        sudo ufw allow 10999/udp     # Don't Starve Together
        sudo ufw allow 10999/tcp     # Don't Starve Together Query
        sudo ufw allow 42420/tcp     # Vintage Story
        sudo ufw --force enable || true

        # Move files to correct locations
        sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
        sudo mv /tmp/rust.docker-compose.yml /opt/rust-server/docker-compose.yml
        sudo mv /tmp/ark.docker-compose.yml /opt/ark/docker-compose.yml
        sudo mv /tmp/minecraft.docker-compose.yml /opt/minecraft/docker-compose.yml
        sudo mv /tmp/tf2.docker-compose.yml /opt/tf2/docker-compose.yml
        sudo mv /tmp/garrysmod.docker-compose.yml /opt/garrysmod/docker-compose.yml
        sudo mv /tmp/insurgency_sandstorm.docker-compose.yml /opt/insurgency-sandstorm/docker-compose.yml
        sudo mv /tmp/squad.docker-compose.yml /opt/squad/docker-compose.yml
        sudo mv /tmp/squad44.docker-compose.yml /opt/squad44/docker-compose.yml
        sudo mv /tmp/satisfactory.docker-compose.yml /opt/satisfactory/docker-compose.yml
        sudo mv /tmp/factorio.docker-compose.yml /opt/factorio/docker-compose.yml
        sudo mv /tmp/eco.docker-compose.yml /opt/eco/docker-compose.yml
        sudo mv /tmp/space_engineers.docker-compose.yml /opt/space-engineers/docker-compose.yml
        sudo mv /tmp/starbound.docker-compose.yml /opt/starbound/docker-compose.yml
        sudo mv /tmp/aoe2de.docker-compose.yml /opt/aoe2de/docker-compose.yml
        sudo mv /tmp/palworld.docker-compose.yml /opt/palworld/docker-compose.yml
        sudo mv /tmp/arma3.docker-compose.yml /opt/arma3/docker-compose.yml
        sudo mv /tmp/minetest.docker-compose.yml /opt/minetest/docker-compose.yml
        sudo mv /tmp/openrct2.docker-compose.yml /opt/openrct2/docker-compose.yml
        sudo mv /tmp/openttd.docker-compose.yml /opt/openttd/docker-compose.yml
        sudo mv /tmp/zeroad.docker-compose.yml /opt/zeroad/docker-compose.yml
        sudo mv /tmp/openra.docker-compose.yml /opt/openra/docker-compose.yml
        sudo mv /tmp/teeworlds.docker-compose.yml /opt/teeworlds/docker-compose.yml
        sudo mv /tmp/xonotic.docker-compose.yml /opt/xonotic/docker-compose.yml
        sudo mv /tmp/ioquake3.docker-compose.yml /opt/ioquake3/docker-compose.yml
        sudo mv /tmp/valheim.docker-compose.yml /opt/valheim/docker-compose.yml
        sudo mv /tmp/valheim_thunderstore.docker-compose.yml /opt/valheim-thunderstore/docker-compose.yml
        sudo mv /tmp/terraria.docker-compose.yml /opt/terraria/docker-compose.yml
        sudo mv /tmp/dont_starve_together.docker-compose.yml /opt/dont-starve-together/docker-compose.yml
        sudo mv /tmp/vintage_story.docker-compose.yml /opt/vintage-story/docker-compose.yml
        sudo mv /tmp/roblox.docker-compose.yml /opt/roblox/docker-compose.yml

        # Handle CS2 Template Replacement
        sudo mkdir -p /opt/cs2
        sudo sed -e "s/__CS2_GSLT__/${var.cs2_gslt}/g" /tmp/cs2.docker-compose.yml | sudo tee /opt/cs2/docker-compose.yml >/dev/null
        sudo rm -f /tmp/cs2.docker-compose.yml

        # Deploy Stacks
        ${var.enable_portainer ? "cd /opt/portainer && (sudo docker rm -f portainer || true) && retry sudo docker compose up -d" : "echo 'Skipping Portainer'"}
        ${var.enable_rust ? "cd /opt/rust-server && (sudo docker rm -f rust-server || true) && retry sudo docker compose up -d && check_and_pause rust-server 600" : "echo 'Skipping Rust'"}
        ${var.enable_ark ? "cd /opt/ark && (sudo docker rm -f ark-server ark_server || true) && retry sudo docker compose up -d && check_and_pause ark-server 600" : "echo 'Skipping ARK'"}
        ${var.enable_cs2 ? "cd /opt/cs2 && (sudo docker rm -f cs2-server cs2_server || true) && retry sudo docker compose up -d && check_and_pause cs2-server 60" : "echo 'Skipping CS2'"}
        ${var.enable_minecraft ? "cd /opt/minecraft && (sudo docker rm -f minecraft-server || true) && retry sudo docker compose up -d && check_and_pause minecraft-server 120" : "echo 'Skipping Minecraft'"}
        ${var.enable_tf2 ? "cd /opt/tf2 && (sudo docker rm -f tf2-server || true) && retry sudo docker compose up -d && check_and_pause tf2-server 60" : "echo 'Skipping TF2'"}
        ${var.enable_garrysmod ? "cd /opt/garrysmod && (sudo docker rm -f garrysmod-server || true) && retry sudo docker compose up -d && check_and_pause garrysmod-server 60" : "echo \"Skipping Garry's Mod\""}
        ${var.enable_insurgency_sandstorm ? "cd /opt/insurgency-sandstorm && (sudo docker rm -f insurgency-sandstorm-server || true) && retry sudo docker compose up -d && check_and_pause insurgency-sandstorm-server 180" : "echo 'Skipping Insurgency: Sandstorm'"}
        ${var.enable_squad ? "cd /opt/squad && (sudo docker rm -f squad-server || true) && retry sudo docker compose up -d && check_and_pause squad-server 300" : "echo 'Skipping Squad'"}
        ${var.enable_squad44 ? "cd /opt/squad44 && (sudo docker rm -f squad44-server || true) && retry sudo docker compose up -d && check_and_pause squad44-server 300" : "echo 'Skipping Squad 44'"}
        ${var.enable_satisfactory ? "cd /opt/satisfactory && (sudo docker rm -f satisfactory-server || true) && retry sudo docker compose up -d && check_and_pause satisfactory-server 120" : "echo 'Skipping Satisfactory'"}
        ${var.enable_factorio ? "cd /opt/factorio && (sudo docker rm -f factorio-server || true) && retry sudo docker compose up -d && check_and_pause factorio-server 60" : "echo 'Skipping Factorio'"}
        ${var.enable_eco ? "cd /opt/eco && (sudo docker rm -f eco-server || true) && retry sudo docker compose up -d && check_and_pause eco-server 180" : "echo 'Skipping Eco'"}
        ${var.enable_space_engineers ? "cd /opt/space-engineers && (sudo docker rm -f space-engineers-server || true) && retry sudo docker compose up -d && check_and_pause space-engineers-server 300" : "echo 'Skipping Space Engineers'"}
        ${var.enable_starbound ? "cd /opt/starbound && (sudo docker rm -f starbound-server || true) && retry sudo docker compose up -d && check_and_pause starbound-server 60" : "echo 'Skipping Starbound'"}
        ${var.enable_aoe2de ? "cd /opt/aoe2de && (sudo docker rm -f aoe2de-server || true) && retry sudo docker compose up -d && check_and_pause aoe2de-server 60" : "echo 'Skipping Age of Empires II: DE'"}
        ${var.enable_palworld ? "cd /opt/palworld && (sudo docker rm -f palworld-server || true) && retry sudo docker compose up -d && check_and_pause palworld-server 300" : "echo 'Skipping Palworld'"}
        ${var.enable_arma3 ? "cd /opt/arma3 && (sudo docker rm -f arma3-server || true) && retry sudo docker compose up -d && check_and_pause arma3-server 300" : "echo 'Skipping Arma 3'"}
        ${var.enable_minetest ? "cd /opt/minetest && (sudo docker rm -f minetest-server || true) && retry sudo docker compose up -d && check_and_pause minetest-server 60" : "echo 'Skipping Minetest'"}
        ${var.enable_openrct2 ? "cd /opt/openrct2 && (sudo docker rm -f openrct2-server || true) && retry sudo docker compose up -d && check_and_pause openrct2-server 60" : "echo 'Skipping OpenRCT2'"}
        ${var.enable_openttd ? "cd /opt/openttd && (sudo docker rm -f openttd-server || true) && retry sudo docker compose up -d && check_and_pause openttd-server 60" : "echo 'Skipping OpenTTD'"}
        ${var.enable_zeroad ? "cd /opt/zeroad && (sudo docker rm -f zeroad-server || true) && retry sudo docker compose up -d && check_and_pause zeroad-server 120" : "echo 'Skipping 0 A.D.'"}
        ${var.enable_openra ? "cd /opt/openra && (sudo docker rm -f openra-server || true) && retry sudo docker compose up -d && check_and_pause openra-server 60" : "echo 'Skipping OpenRA'"}
        ${var.enable_teeworlds ? "cd /opt/teeworlds && (sudo docker rm -f teeworlds-server ddnet-server || true) && retry sudo docker compose up -d && check_and_pause teeworlds-server 60" : "echo 'Skipping Teeworlds/DDNet'"}
        ${var.enable_xonotic ? "cd /opt/xonotic && (sudo docker rm -f xonotic-server || true) && retry sudo docker compose up -d && check_and_pause xonotic-server 60" : "echo 'Skipping Xonotic'"}
        ${var.enable_ioquake3 ? "cd /opt/ioquake3 && (sudo docker rm -f ioquake3-server || true) && retry sudo docker compose up -d && check_and_pause ioquake3-server 60" : "echo 'Skipping ioquake3'"}
        ${var.enable_valheim ? "cd /opt/valheim && (sudo docker rm -f valheim-server || true) && retry sudo docker compose up -d && check_and_pause valheim-server 120" : "echo 'Skipping Valheim'"}
        ${var.enable_valheim_thunderstore ? "cd /opt/valheim-thunderstore && (sudo docker rm -f valheim-thunderstore-server || true) && retry sudo docker compose up -d && check_and_pause valheim-thunderstore-server 180" : "echo 'Skipping Valheim (Thunderstore)'"}
        ${var.enable_terraria ? "cd /opt/terraria && (sudo docker rm -f terraria-server || true) && retry sudo docker compose up -d && check_and_pause terraria-server 60" : "echo 'Skipping Terraria / tModLoader'"}
        ${var.enable_dont_starve_together ? "cd /opt/dont-starve-together && (sudo docker rm -f dont-starve-together-server || true) && retry sudo docker compose up -d && check_and_pause dont-starve-together-server 120" : "echo 'Skipping Don't Starve Together'"}
        ${var.enable_vintage_story ? "cd /opt/vintage-story && (sudo docker rm -f vintage-story-server || true) && retry sudo docker compose up -d && check_and_pause vintage-story-server 60" : "echo 'Skipping Vintage Story'"}
        ${var.enable_roblox ? "cd /opt/roblox && (sudo docker rm -f roblox-studio || true) && retry sudo docker compose up -d" : "echo 'Skipping Roblox Studio'"}
REMOTE_SCRIPT
    EOT
  }
}
