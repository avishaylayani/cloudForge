FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y apt-utils vim wget curl git 

ENV JENKINS_OPTS="--httpPort=800 "
# ENV JENKINS_OPTS="--httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/lib/jenkins/certificate.pfx --httpsKeyStorePassword=Password12"
EXPOSE 800