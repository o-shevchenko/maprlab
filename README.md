# maprlab
Tool for instalation MapR cluster by MapR Installer

## Run

### Prerequisites
1. Install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) 

### Steps
1. cd maprlab/centos
2. docker build --rm -t maprcentos .
3. cd maprlab/mapr-installer
4. docker build -t maprinstaller .
5. docker-compose up -d --scale centos7=2 (specify needed number of nodes in a cluster)
