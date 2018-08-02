# maprlab
Tool for instalation MapR cluster by MapR Installer

## Run

### Prerequisites
1. Install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/)
2. To use separated disk/partition for each container use [devicemapper](https://docs.docker.com/storage/storagedriver/device-mapper-driver/) as device driver and configure disk via loop-lvm or direct-lvm. Do not use loop-lvm for performance testing since it slow. Use instead direct-lvm and preconfigure real cluster disks.
    1. Create the file 'sudo vim /etc/docker/daemon.json'
    2. Specify the following properties in daemon.json (for loop-lvm):
        ```
        {
          "storage-driver": "devicemapper",
          "storage-opts": [
            "dm.basesize=50G"
          ]
        }
        ```
    3. sudo service docker stop
    4. sudo rm -rf /var/lib/docker (take a note that you delete all your docker data!!!)
    5. sudo service docker start

### Build and run
1. cd maprlab/centos
2. docker build --rm -t maprcentos7 .
3. cd maprlab/mapr-installer
4. docker build -t maprinstaller .
5. docker-compose up -d --scale node=2 (specify needed number of nodes in a cluster)
