#!/bin/bash
set -x
sudo yum install httpd
sudo yum update
sudo yum install wget
sudo systemctl start httpd
sudo systemctl enable httpd.service
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
nohup busybox httpd -f -p 8080