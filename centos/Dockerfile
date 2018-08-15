FROM centos:centos7

ENV container docker

# Add mapr user
RUN adduser mapr -u 5000
RUN gpasswd -a mapr wheel
RUN gpasswd -a mapr root
RUN echo 'mapr:mapr' | chpasswd

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y curl initscripts net-tools nfs-utils rpcbind sudo wget which openssh-clients openssh-server sshpass maven && yum -q clean all

# Configure SSHD
RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
# http://stackoverflow.com/questions/2419412/ssh-connection-stop-at-debug1-ssh2-msg-kexinit-sent
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# Bad security, add a user and sudo instead!
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
# http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Deploy ssh keys
RUN mkdir /root/.ssh/ && \
	echo "ssh-rsa AAAAB3Nz4........l9Ns5p989oHLcSGJ" > ~/.ssh/authorized_keys && \
	chmod 700 ~/.ssh && \
	chmod 600 ~/.ssh/authorized_keys

RUN mkdir /home/mapr/.ssh/ && \
	echo "ssh-rsa AAAAB3NzaC........9Ns5p989oHLcSGJ" > /home/mapr/.ssh/authorized_keys && \
	chmod 700 /home/mapr/.ssh && \
	chmod 600 /home/mapr/.ssh/authorized_keys && \
	chown -R mapr:mapr /home/mapr/.ssh/

RUN bash -c 'echo "mapr ALL=(ALL:ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'

EXPOSE 22

CMD ["/usr/sbin/init"]