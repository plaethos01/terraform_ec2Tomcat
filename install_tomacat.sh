#!/bin/bash

# Install Java
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk

# Download Tomcat
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.73/bin/apache-tomcat-9.0.73.tar.gz
# Extract Tomcat archive
sudo tar -xvf apache-tomcat-9.0.73.tar.gz -C /opt

# Rename Tomcat directory
sudo mv /opt/apache-tomcat-9.0.73 /opt/tomcat

# Create Tomcat user
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Update Tomcat directory permissions
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod g+x /opt/tomcat/conf
sudo chown -R tomcat /opt/tomcat/logs/ /opt/tomcat/temp/ /opt/tomcat/webapps/ /opt/tomcat/work/

# Create Tomcat service file
sudo touch /etc/systemd/system/tomcat.service
sudo chmod 666 /etc/systemd/system/tomcat.service

# Add Tomcat service configuration
echo "[Unit]" >> /etc/systemd/system/tomcat.service
echo "Description=Tomcat Server" >> /etc/systemd/system/tomcat.service
echo "After=network.target" >> /etc/systemd/system/tomcat.service
echo "" >> /etc/systemd/system/tomcat.service
echo "[Service]" >> /etc/systemd/system/tomcat.service
echo "Type=forking" >> /etc/systemd/system/tomcat.service
echo "User=tomcat" >> /etc/systemd/system/tomcat.service
echo "Group=tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_HOME=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_BASE=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "ExecStart=/opt/tomcat/bin/startup.sh" >> /etc/systemd/system/tomcat.service
echo "ExecStop=/opt/tomcat/bin/shutdown.sh" >> /etc/systemd/system/tomcat.service
echo "Restart=on-failure" >> /etc/systemd/system/tomcat.service
echo "" >> /etc/systemd/system/tomcat.service
echo "[Install]" >> /etc/systemd/system/tomcat.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service

# Configure Tomcat users
sudo sed -i '$ a <role rolename="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml
sudo sed -i '$ a <user username="'${1}'" password="'${2}'" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml


# Reload systemctl daemon
sudo systemctl daemon-reload

# Start Tomcat service
sudo systemctl start tomcat

# Enable Tomcat service to start at boot
sudo systemctl enable tomcat

# Clean up downloaded files
sudo rm apache-tomcat-9.0.73.tar.gz
