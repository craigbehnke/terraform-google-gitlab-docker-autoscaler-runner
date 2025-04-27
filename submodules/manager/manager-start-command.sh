echo "Installing the fleeting plugin" && \
sudo docker run \
    -v /runner/etc:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /runner/bin:/usr/local/bin \
    -v /root/.ssh:/root/.ssh \
    -v /etc/ssh:/etc/ssh \
    -e TZ="${TIMEZONE}" \
    -e DOCKER_HOST="unix:///run/docker.sock" \
    -e FLEETING_PLUGIN_PATH="/usr/local/bin" \
    --privileged \
    --network host \
    gitlab/gitlab-runner:ubuntu-92594782 \
    fleeting install && \
    # We want to install the fleeting plugin for the system before we run the system itself

echo "Starting the runner" && \
sudo docker run -d --name gitlab-runner --restart always \
    -v /runner/etc:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /runner/bin:/usr/local/bin \
    -v /root/.ssh:/root/.ssh \
    -v /etc/ssh:/etc/ssh \
    -e TZ="${TIMEZONE}" \
    -e DOCKER_HOST="unix:///run/docker.sock" \
    -e FLEETING_PLUGIN_PATH="/usr/local/bin" \
    --privileged \
    --network host \
    gitlab/gitlab-runner:ubuntu-92594782 \
    run --working-directory=/home/gitlab-runner --user=root
    # This last line ^^ is for the runner system to start within the docker containerd