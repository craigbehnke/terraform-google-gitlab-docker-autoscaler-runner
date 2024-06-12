#! /bin/bash

# Create the local config directory
mkdir -p /runner/etc
mkdir -p /runner/bin

# Disable host fingerprint checking
echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Download static private key
curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh-key-to-use -H 'Metadata-Flavor: Google' -o /root/.ssh/id_rsa

# Install Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



# Create the config file
curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/config -H 'Metadata-Flavor: Google' -o /runner/etc/config.toml

# Download the latest version of fleeting plugin
curl https://gitlab.com/api/v4/projects/39455486/packages/generic/releases/v0.2.0/fleeting-plugin-googlecompute-linux-amd64 \
    -o /runner/bin/fleeting-plugin-googlecompute

chmod 777 /runner/bin/fleeting-plugin-googlecompute

# Execute the start command
# This is stored in the runner-start-command.sh file so that it can be easily repeated in terraform
${MANAGER_START_COMMAND}

echo "sudo docker stop gitlab-runner && sudo docker rm gitlab-runner && ${MANAGER_START_COMMAND}" >> /runner/restart.sh
chmod 777 /runner/restart.sh


echo "###################################################"
echo "## Runner is online."
echo "## Setup is continuing."
echo "###################################################"

# Install Google Cloud Operations Agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

sudo apt-get update
sudo apt-get install nano -y
sudo apt-get upgrade -y

echo "###################################################"
echo "## Virtual machine setup complete."
echo "## It better be working!"
echo "###################################################"
