FROM centos:centos7

ENV container docker

RUN yum update -qq && yum install --no-install-recommends -q -y curl sudo tzdata wget python-minimal openssh-client openssh-server sshpass sysv-rc-conf uuid-runtime openjdk-8-jre-headless && yum autoremove --purge -q -y && rm -rf /var/lib/apt/lists/* && yum clean -q

COPY mapr-setup.sh /opt/mapr/installer/docker/

EXPOSE 22 9443

RUN /opt/mapr/installer/docker/mapr-setup.sh -r http://package.mapr.com/releases container installer

ENTRYPOINT ["/opt/mapr/installer/docker/mapr-setup.sh", "container"]
