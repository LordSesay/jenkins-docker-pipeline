FROM jenkins/jenkins:lts

USER root

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    usermod -aG docker jenkins

# Install plugins
RUN jenkins-plugin-cli --plugins \
    docker-workflow \
    pipeline-aws \
    git \
    pipeline-stage-view

USER jenkins