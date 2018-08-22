# Up cluster nodes
cd /root/maprlab
sudo docker-compose up -d --scale node=2
sudo docker rename maprlab_node_1 node1.cluster.com
sudo docker rename maprlab_node_2 node2.cluster.com

# Change hostname
sudo docker exec -i node1.cluster.com bash -c 'cp /etc/hosts ~/hosts.new ; sed -i 's/'$(hostname)'/node1.cluster.com/g'  ~/hosts.new ; cp -f ~/hosts.new /etc/hosts'
sudo docker exec -i node1.cluster.com bash -c 'cp /etc/hostname ~/hostname.new ; sed -i 's/'$(hostname)'/node1.cluster.com/g'  ~/hostname.new ; cp -f ~/hostname.new /etc/hostname'
sudo docker exec -i node1.cluster.com hostname node1.cluster.com

sudo docker exec -i node2.cluster.com bash -c 'cp /etc/hosts ~/hosts.new ; sed -i 's/'$(hostname)'/node2.cluster.com/g'  ~/hosts.new ; cp -f ~/hosts.new /etc/hosts'
sudo docker exec -i node2.cluster.com bash -c 'cp /etc/hostname ~/hostname.new ; sed -i 's/'$(hostname)'/node2.cluster.com/g'  ~/hostname.new ; cp -f ~/hostname.new /etc/hostname'
sudo docker exec -i node2.cluster.com hostname node2.cluster.com

sleep 30s

# Change repo to current version
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sed -i '/repo_core_url/c\   \"repo_core_url\" : \"http://cv:Artifactory4CV!@34.197.167.22/artifactory/prestage/releases-dev\",' /opt/mapr/installer/data/properties.json
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sed -i '/repo_eco_url/c\   \"repo_eco_url\" : \"http://cv:Artifactory4CV!@34.197.167.22/artifactory/prestage/releases-dev\",' /opt/mapr/installer/data/properties.json
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sudo service mapr-installer restart

sleep 30s

# Run installation via Installer CLI
sudo docker exec -i --user mapr maprlab_maprinstaller_1 ./opt/mapr/installer/bin/mapr-installer-cli install -nv -t /opt/mapr/installer/docker/conf/installer_stanza.yaml -f

sleep 30s

# Create mapr ticket
sudo docker exec -i --user mapr node1.cluster.com bash -c 'echo -e "mapr\n" | maprlogin password'
sudo docker exec -i --user mapr node2.cluster.com bash -c 'echo -e "mapr\n" | maprlogin password'

# Run tests
TEST_RES_FILE_PATH="/home/mapr/private-qa/new-ats/mapreduce/surefire-reports/smoke/mapreduce-tests/testng-results.xml"
JOB_PATH="/var/lib/jenkins/workspace/Hadoop_test/"
sudo docker exec -i --user mapr node1.cluster.com git clone -b $testBranch --depth 1 --single-branch https:\/\/o-shevchenko:maprgithub1@github.com\/mapr\/private-qa.git /home/mapr/private-qa
sudo docker exec -i --user mapr node1.cluster.com bash -c 'cd /home/mapr/private-qa/new-ats/ ; chmod +x hadoop.sh ; ./hadoop.sh master ; mvn clean install -fae'

sudo docker exec -i --user mapr node1.cluster.com bash -c 'cd /home/mapr/private-qa/new-ats/mapreduce/mapreduce-tests/ && mvn clean install -Psmoke'

# Copy test result from Docker container
docker cp node1.cluster.com:$TEST_RES_FILE_PATH $JOB_PATH

# Destroy cluster
sudo docker-compose down