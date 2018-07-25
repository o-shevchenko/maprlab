FROM centos:centos7

RUN yum install -y curl initscripts net-tools sudo wget which openssh-clients openssh-server sshpass java-1.8.0-openjdk-headless && yum -q clean all
RUN sshd-keygen
RUN adduser mapr -u 5000
RUN gpasswd -a mapr wheel
RUN echo 'mapr:mapr' | chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]