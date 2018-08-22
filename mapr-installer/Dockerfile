FROM centos:centos7

ENV container docker

RUN yum install -y curl initscripts net-tools sudo wget which openssh-clients openssh-server sshpass vim java-1.8.0-openjdk-headless && yum -q clean all

LABEL mapr.os=centos7

COPY mapr-setup.sh /opt/mapr/installer/docker/
EXPOSE 22 9443

RUN /opt/mapr/installer/docker/mapr-setup.sh -r 'http://cv:Artifactory4CV!@34.197.167.22/artifactory/prestage/releases-dev' container installer
# RUN /opt/mapr/installer/docker/mapr-setup.sh -r http://package.mapr.com/releases container installer

ENTRYPOINT ["/opt/mapr/installer/docker/mapr-setup.sh", "container"]