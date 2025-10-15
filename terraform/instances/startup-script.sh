#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "Hello from $(hostname) $(hostname -i)" > /var/www/html/index.html
sudo systemctl restart apache2
