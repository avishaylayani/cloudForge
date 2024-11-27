FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y apt-utils vim wget curl git openssh-server default-jre
RUN ( useradd -s /bin/bash -m jenkins || echo "User exists" ) && echo 'jenkins:jenkins' | chpasswd && ssh-keygen -A && \
     echo 'jenkins    ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers
ENV JENKINS_OPTS="--httpPort=800 "
# ENV JENKINS_OPTS="--httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/lib/jenkins/certificate.pfx --httpsKeyStorePassword=Password12"
EXPOSE 800
CMD service ssh start && exec /usr/local/bin/jenkins.sh
