# Up cluster nodes
cd /root/maprlab
sudo docker-compose up -d --scale node=2
sudo docker rename maprlab_node_1 node1.cluster.com
sudo docker rename maprlab_node_2 node2.cluster.com

sleep 30s

# Change repo to current version
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sed -i '/repo_core_url/c\   \"repo_core_url\" : \"http://cv:Artifactory4CV!@34.197.167.22/artifactory/prestage/releases-dev\",' /opt/mapr/installer/data/properties.json
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sed -i '/repo_eco_url/c\   \"repo_eco_url\" : \"http://cv:Artifactory4CV!@34.197.167.22/artifactory/prestage/releases-dev\",' /opt/mapr/installer/data/properties.json
sudo docker exec -i --user mapr maprlab_maprinstaller_1 sudo service mapr-installer restart

sleep 30s

# Run installation via Installer CLI
sudo docker exec -i --user mapr maprlab_maprinstaller_1 ./opt/mapr/installer/bin/mapr-installer-cli install -nv -t /opt/mapr/installer/examples/installer_stanza.yaml -f

# Run tests
sudo docker exec -i --user mapr node1.cluster.com git clone -b $testBranch --depth 1 --single-branch https:\/\/c06048acc56b0ab1037f3db53ef2a15267a9ad9e@github.com\/mapr\/private-qa.git /home/mapr/private-qa
sudo docker exec -i --user mapr node1.cluster.com bash -c 'cd /home/mapr/private-qa/new-ats/ ; chmod +x hadoop.sh ; ./hadoop.sh master ; mvn clean install -fae'

sudo docker exec -i --user mapr node1.cluster.com bash -c 'cd /home/mapr/private-qa/new-ats/mapreduce/mapreduce-tests/ && mvn clean install -Pfunctional'