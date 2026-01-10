# Gaming Server

This project manages a gaming server running various Docker stacks using Terraform, with a focus on self-hosted game servers and Portainer for management.

## Project Structure
```
infra/            # Terraform configuration
  bootstrap.sh    # Manual bootstrap script (optional)
  main.tf         # Main Terraform logic
  variables.tf    # Variable definitions
  outputs.tf      # Deployment outputs
  stacks/         # Docker Compose files grouped by purpose
    # Game servers
    ark/ cs2/ minecraft/ rust/ tf2/ garrysmod/ insurgency_sandstorm/ squad/ squad44/
    satisfactory/ factorio/ eco/ space_engineers/ starbound/ aoe2de/ palworld/ arma3/
    minetest/ openrct2/ openttd/ zeroad/ openra/ teeworlds/ xonotic/ ioquake3/
    valheim/ valheim_thunderstore/ terraria/ dont_starve_together/ vintage_story/ roblox/
    portainer/
```

## Deployment

1. **Bootstrap and Deploy:**
   Run Terraform from the `infra/` directory. This will bootstrap the server (install Docker) and deploy your selected stacks.

   ```bash
   cd infra
   terraform init
   terraform apply \
     -var="docker_host=ssh://michael@192.168.86.42" \
     -var="cs2_gslt=YOUR_STEAM_TOKEN" \
     -var="enable_portainer=true" \
     -var="enable_rust=true" \
     -var="enable_ark=true" \
     -var="enable_cs2=true" \
     -var="enable_minecraft=true" \
     -var="enable_tf2=true" \
     -var="enable_garrysmod=true" \
     -var="enable_insurgency_sandstorm=true" \
     -var="enable_squad=true" \
     -var="enable_squad44=true" \
     -var="enable_satisfactory=true" \
     -var="enable_factorio=true" \
     -var="enable_eco=true" \
     -var="enable_space_engineers=true" \
     -var="enable_starbound=true" \
     -var="enable_aoe2de=true" \
     -var="enable_palworld=true" \
     -var="enable_arma3=true" \
     -var="enable_minetest=true" \
     -var="enable_openrct2=true" \
     -var="enable_openttd=true" \
     -var="enable_zeroad=true" \
     -var="enable_openra=true" \
     -var="enable_teeworlds=true" \
     -var="enable_xonotic=true" \
     -var="enable_ioquake3=true" \
     -var="enable_valheim=true" \
     -var="enable_valheim_thunderstore=true" \
     -var="enable_terraria=true" \
     -var="enable_dont_starve_together=true" \
     -var="enable_vintage_story=true" \
     -var="enable_roblox=true"
   ```

   **Note:** replace `192.168.86.42` with your actual server IP.

2. **Accessing Portainer:**
   * **Portainer:** `http://<server-ip>:9000`

   Terraform's remote bootstrap automatically opens UFW for HTTP/HTTPS (80/443) and every game port configured in the Compose files so the services bind to `0.0.0.0` and remain reachable externally.

3. **Game Server Catalog & Connection Info:** (links go to the official game pages and the ports reflect the Terraform Docker Compose stacks.)

   | Game | Ports to Expose (host side) | How to Join from the Game Client |
   | --- | --- | --- |
   | [Rust](https://rust.facepunch.com/) | Game: `<server-ip>:28015`, Query/RCON: `<server-ip>:28016` (UDP/TCP) | Press ``F1`` to open the console, run `connect <server-ip>:28015`. |
   | [ARK: Survival Evolved](https://store.steampowered.com/app/346110/ARK_Survival_Evolved/) | Game UDP: `<server-ip>:7777`, Alt UDP: `<server-ip>:7778`, Query UDP: `<server-ip>:27016` | In **Join ARK**, add the server to favorites with `steam://connect/<server-ip>:7777` or via the in-game favorites list using the game port (7777). |
   | [Counter-Strike 2](https://store.steampowered.com/app/730/CounterStrike_2/) | TCP/UDP: `<server-ip>:27015` | In the developer console, run `connect <server-ip>:27015`, or add the IP/port under Community Servers > Favorites. |
   | [Minecraft](https://www.minecraft.net/) | TCP: `<server-ip>:25565` | **Paper 1.21.11**. Direct Connect to `<server-ip>` (port 25565). No Monsters, 12 Chunk Distance. |
   | [Team Fortress 2](https://store.steampowered.com/app/440/Team_Fortress_2/) | TCP/UDP: `<server-ip>:27017` | Open **Browse Servers** → **Favorites** → **Add a Server**, enter `<server-ip>:27017`, then connect. |
   | [Garry’s Mod](https://store.steampowered.com/app/4000/Garrys_Mod/) | TCP/UDP: `<server-ip>:27018`, Extra UDP: `<server-ip>:27008` | In the main menu, open **Find Multiplayer Game** → **Legacy Browser** → **Favorites**, add `<server-ip>:27018`, then connect. |
   | [Insurgency: Sandstorm](https://store.steampowered.com/app/581320/Insurgency_Sandstorm/) | Game UDP: `<server-ip>:27102`, Query UDP: `<server-ip>:27131` | From the Play menu, use the server browser Filters → Favorites, add `<server-ip>:27102`, then refresh and join. |
   | [Squad](https://joinsquad.com/) | Game UDP: `<server-ip>:7787`, Query UDP: `<server-ip>:27165` | In the server browser, open **Favorites**, click **Add Server**, input `<server-ip>:7787`, refresh, and connect. |
   | [Squad 44 (Post Scriptum)](https://store.steampowered.com/app/736220/Post_Scriptum/) | Game UDP: `<server-ip>:10027`, Query UDP: `<server-ip>:10037` | Use the in-game server browser Favorites tab, add `<server-ip>:10027`, refresh, and join. |
   | [Satisfactory](https://www.satisfactorygame.com/) | UDP: `<server-ip>:7779`, `<server-ip>:15000`, `<server-ip>:15777` | From the main menu choose **Server Manager** → **Add Server**, enter `<server-ip>`, set port to `7779`, then authenticate when prompted; additional ports are handled automatically. |
   | [Factorio](https://factorio.com/) | Game UDP: `<server-ip>:34197`, RCON TCP: `<server-ip>:27022` | In Multiplayer → Connect to address, enter `<server-ip>:34197`; use RCON tools against port 27022 if configured. |
   | [Eco](https://store.steampowered.com/app/382310/Eco/) | TCP: `<server-ip>:3000`, UDP: `<server-ip>:3001` | From the main menu, open **Your Worlds** → **Join**, enter `<server-ip>:3000`, and connect. |
   | [Space Engineers](https://store.steampowered.com/app/244850/Space_Engineers/) | UDP: `<server-ip>:27019`, `<server-ip>:8766` | In the Join Game menu, switch to **Favorites**, add `<server-ip>:27019`, and connect after it appears. |
   | [Starbound](https://store.steampowered.com/app/211820/Starbound/) | TCP: `<server-ip>:21025` | From the main menu, click **Join Game**, enter `<server-ip>` and port `21025`, then join. |
   | [Age of Empires II: Definitive Edition](https://www.ageofempires.com/games/aoeiide/) | UDP: `<server-ip>:27020`, `<server-ip>:27021` | **Placeholder**. Server is not currently functional (waiting for Wine image). |
   | [Palworld](https://store.steampowered.com/app/1623730/PALWORLD/) | UDP: `<server-ip>:8211`, Query UDP: `<server-ip>:27023` | In **Join Multiplayer** enter `<server-ip>:8211` (or share an invite code if enabled); keep query port 27023 open for listings. |
   | [Arma 3](https://store.steampowered.com/app/107410/Arma_3/) | UDP: `<server-ip>:2302-2305` | From the Launcher server browser, add `<server-ip>` to Favorites (default port 2302), refresh, and connect; ensure 2303-2305 remain open for Steam queries. |
   | [Minetest](https://www.minetest.net/) | UDP: `<server-ip>:30000` | In Multiplayer, click **Add Server** and enter `<server-ip>` with port `30000`, then join. |
   | [OpenRCT2](https://openrct2.io/) | TCP/UDP: `<server-ip>:11753` | From the main menu, open **Multiplayer** → **Direct connect** and enter `<server-ip>:11753`; ensure you have the original game assets. |
   | [OpenTTD](https://www.openttd.org/) | TCP/UDP: `<server-ip>:3979` | In Multiplayer, add `<server-ip>:3979` as a server or connect via LAN/Internet lists after forwarding both ports. |
   | [0 A.D.](https://play0ad.com/) | UDP: `<server-ip>:20595` | In **Multiplayer**, choose **Host/Join**, then direct connect to `<server-ip>:20595` (share any password you set). |
   | [OpenRA](https://www.openra.net/) | TCP/UDP: `<server-ip>:1234` | From the main menu, choose **Multiplayer** → **Direct Connect** and enter `<server-ip>:1234`. |
   | [Teeworlds / DDNet](https://www.teeworlds.com/) | UDP: `<server-ip>:8303` (Teeworlds), `<server-ip>:8304` (DDNet) | Add `<server-ip>:8303` to favorites in the in-game browser for vanilla, or `<server-ip>:8304` for DDNet; refresh and join. |
   | [Xonotic](https://xonotic.org/) | UDP/TCP: `<server-ip>:26000` | Open **Multiplayer** → **Servers**, add a favorite or console connect to `<server-ip>:26000`. |
   | [ioquake3 / Quake 3](https://ioquake3.org/) | UDP: `<server-ip>:27960` | Open the console and run `connect <server-ip>:27960`, or add a favorite server with that address. |
   | [Valheim](https://www.valheimgame.com/) | UDP: `<server-ip>:2456-2458` | From the in-game **Join Game** screen, add a favorite with `<server-ip>:2456` and the configured password; the extra ports handle queries. |
   | [Valheim (Thunderstore modpack)](https://thunderstore.io/c/valheim/) | UDP: `<server-ip>:2456-2458` | Same as Valheim; this stack pre-installs Thunderstore modpack support for Mistlands collections. |
   | [Terraria / tModLoader](https://terraria.org/) | TCP: `<server-ip>:7777` | From the multiplayer menu, choose **Join via IP**, enter `<server-ip>` and port `7777`, then provide the server password if set. |
   | [Don't Starve Together](https://www.klei.com/games/dont-starve-together) | TCP/UDP: `<server-ip>:10999` | Add the server via the in-game **Favorites** tab with `<server-ip>:10999`; share the cluster token/password with friends. |
   | [Vintage Story](https://www.vintagestory.at/) | TCP: `<server-ip>:42420` | On the main menu, open **Join Game**, enter `<server-ip>` and port `42420`, then connect with the configured password if enabled. |
   | Roblox Studio (Webtop) | TCP: `<server-ip>:3100` (web), TCP: `<server-ip>:3101` (noVNC) | Open `http://<server-ip>:3100` in your browser, authenticate with the password from the compose file (`PASSWORD`, defaults to `change-me`), then install/run Roblox Studio from the desktop session. |

   **Roblox Studio security tip:** Update the `PASSWORD` environment variable in `infra/stacks/roblox/docker-compose.yml` before deploying so the remote desktop is protected.

## System Prerequisites
Before running Terraform, you must ensure:
1.  **SSH Access:** Keys are copied to the server (`ssh-copy-id`).
2.  **Passwordless Sudo:** The user must be able to run sudo without a password for Terraform automation.
    Run this on the server (or via SSH) once:
    ```bash
    ssh -t michael@<server-ip> "echo 'michael ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/michael"
    ```

## Bootstrapping Details
Terraform uses SSH to connect to the server. Ensure you have:
1. SSH access to the server via public key (`ssh-copy-id`).
2. Sudo privileges on the server (NOPASSWD recommended).

## Debugging & Logs

To check the logs for a specific server, you can SSH into the server and use `docker logs`.

**Command:**
```bash
ssh michael@192.168.86.42 "sudo docker logs -f <container_name>"
```

**Common Container Names:**

| Service | Container Name |
| --- | --- |
| AoE II: DE | `aoe2de-server` |
| ARK | `ark-server` |
| Arma 3 | `arma3-server` |
| CS2 | `cs2-server` |
| Eco | `eco-server` |
| Factorio | `factorio-server` |
| Garry's Mod | `garrysmod-server` |
| Insurgency: Sandstorm | `insurgency-sandstorm-server` |
| ioquake3 | `ioquake3-server` |
| Minecraft | `minecraft-server` |
| Minetest | `minetest-server` |
| OpenRA | `openra-server` |
| OpenRCT2 | `openrct2-server` |
| OpenTTD | `openttd-server` |
| Palworld | `palworld-server` |
| Portainer | `portainer` |
| Rust | `rust-server` |
| Satisfactory | `satisfactory-server` |
| Space Engineers | `space-engineers-server` |
| Squad | `squad-server` |
| Squad 44 | `squad44-server` |
| Starbound | `starbound-server` |
| Teeworlds | `teeworlds-server` |
| Teeworlds (DDNet) | `ddnet-server` |
| Roblox Studio | `roblox-studio` |
| TF2 | `tf2-server` |
| Xonotic | `xonotic-server` |
| 0 A.D. | `zeroad-server` |
| Valheim | `valheim-server` |
| Valheim (Thunderstore) | `valheim-thunderstore-server` |
| Terraria / tModLoader | `terraria-server` |
| Don't Starve Together | `dont-starve-together-server` |
| Vintage Story | `vintage-story-server` |

