sudo docker run -d --name gitlab-runner --restart always \
    -v /runner/etc:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /runner/bin:/usr/local/bin \
    -v /root/.ssh:/root/.ssh \
    -v /etc/ssh:/etc/ssh \
    -e TZ=America/Chicago \
    -e DOCKER_HOST="unix:///run/docker.sock" \
    --privileged \
    --network host \
    gitlab/gitlab-runner:latest \
    run --working-directory=/home/gitlab-runner --user=root
    # This last line ^^ is for the runner system to start within the docker container