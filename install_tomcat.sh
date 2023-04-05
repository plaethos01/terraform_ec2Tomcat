#!/bin/bash

# Install Java
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk

# Download Tomcat
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.56/bin/apache-tomcat-9.0.56.tar.gz

# Extract Tomcat
sudo tar -zxvf apache-tomcat-9.0.56.tar.gz
sudo mv apache-tomcat-9.0.56 /usr/local/tomcat

# Create Tomcat user
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /usr/local/tomcat tomcat
sudo chown -R tomcat:tomcat /usr/local/tomcat

# Configure Tomcat users
sudo sed -i '$ a <role rolename="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml
sudo sed -i '$ a <user username="'${1}'" password="'${2}'" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml

# Start Tomcat
sudo systemctl enable tomcat

# Start Tomcat service
sudo systemctl start tomcat

