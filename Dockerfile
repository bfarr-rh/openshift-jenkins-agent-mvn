FROM registry.redhat.io/ocp-tools-4/jenkins-agent-base-rhel9:v4.22.0-1787125563

USER root

RUN yum install -y maven



# 2. Setup the .m2 directory with dynamic group permissions (Root Group 0)
#    OpenShift/RedHat containers dynamically run as random user IDs belonging to group 0.
RUN mkdir -p /home/jenkins/.m2/repository && \
    chgrp -R 0 /home/jenkins/.m2 && \
    chmod -R g+rwX /home/jenkins/.m2

# FORCE Maven's settings.xml to hardcode /home/jenkins/.m2/repository
RUN echo '<?xml version="1.0" encoding="UTF-8"?> \
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" \
          xmlns:xsi="http://w3.org" \
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://apache.org"> \
  <localRepository>/home/jenkins/.m2/repository</localRepository> \
</settings>' > /usr/share/maven/conf/settings.xml


# 3. Revert to the default unprivileged UID used by the base image
USER 1001
