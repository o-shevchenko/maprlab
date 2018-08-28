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

3. To use real cluster hardware you can create needed disk by LVM (to use by MapR-FS):
    1. Create physical volume from existing disk
        ```
        pvcreate /dev/sdf
        ```
    2. Create the a volume group that consists of the LVM physical volumes you have created.
        ``` 
        vgcreate maprfsvg /dev/sdf
        ```
    3. Create the logical volume from the volume group you have created. 
        This example creates a logical volume that uses 50 gigabytes of the volume group.
        ```
        lvcreate -L 50G -n maprfslv maprfsvg
        ```

4. If you want to run containers on multiple hosts (for example on performance cluster) you can use [Docker Swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/)

### Build and run
1. cd maprlab/centos
2. docker build --rm -t maprcentos7 .
3. cd maprlab/mapr-installer
4. docker build -t maprinstaller .
5. docker-compose up -d --scale node=2 (specify needed number of nodes in a cluster)

### Install cluster
1. Set needed configuration in installer_stanza.yaml
2. Run the following command in Installer container
    ```
    ./opt/mapr/installer/bin/mapr-installer-cli install -nv -t /opt/mapr/installer/docker/conf/installer_stanza.yaml -f
    ```

### Troubleshooting
1. Java OOM
    Symptoms: java.lang.OutOfMemoryError: unable to create new native thread
    Solution: Increase Linux system threads limit 
        ```
        ulimit -u <number of threads>
        or change default values in the following file (on a host machine):
        /etc/security/limits.conf
        
        Add to end of file:
        mapr - nofile 65536
        mapr - nproc 64000
        mapr - memlock unlimited
        mapr - core unlimited
        mapr - nice -10
        ```      