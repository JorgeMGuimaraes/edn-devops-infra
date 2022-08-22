#! /bin/bash

# Script  to allow user to automate Jenkins install and setup process.
# Based on https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code
# but with updates:
#   - this script creates / downloads all files
#   - using Jenkins Plugin Manager jar (a workaroud for install-plugins.sh)

# variables
jcasc_dir=$HOME/playground/jcasc
jpm=jenkins-plugin-manager
jpm_release=2.12.8
ip='192.168.122.214'

# set dir
mkdir -p $jcasc_dir
cd $jcasc_dir

# Download Jenkins plugin manager
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/$jpm_release/$jpm-$jpm_release.jar
mv $jpm-$jpm_release.jar $jpm.jar

# Create plugins list
cat << EOF > plugins.txt
ant:latest
antisamy-markup-formatter:latest
authorize-project:latest
build-timeout:latest
cloudbees-folder:latest
configuration-as-code:latest
credentials-binding:latest
email-ext:latest
git:latest
github-branch-source:latest
gradle:latest
ldap:latest
mailer:latest
matrix-auth:latest
pam-auth:latest
pipeline-github-lib:latest
pipeline-stage-view:latest
ssh-slaves:latest
timestamper:latest
workflow-aggregator:latest
ws-cleanup:latest
EOF

# Create configuration as code
cat << \EOF > casc.yaml
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: ${JENKINS_ADMIN_ID}
          password: ${JENKINS_ADMIN_PASSWORD}
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
  remotingSecurity:
    enabled: true
security:
  queueItemAuthenticator:
    authenticators:
    - global:
        strategy: triggeringUsersAuthorizationStrategy
unclassified:
  location:
    url: http://127.0.0.1:8080/
EOF

# Create Docker file
cat << EOF > Dockerfile
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY casc.yaml /var/jenkins_home/casc.yaml
WORKDIR /usr/share/jenkins/ref/
COPY $jpm.jar ./$jpm.jar
COPY plugins.txt ./plugins.txt
RUN java -jar $jpm.jar -f plugins.txt --verbose
EOF

docker build -t jenkins:jcasc .

# Run docker:
docker run \
  --name jenkins\
  --rm \
  -p 8080:8080 \
  --env JENKINS_ADMIN_ID=admin_xxxxxx \
  --env JENKINS_ADMIN_PASSWORD=password_xxxxxx \
   jenkins:jcas