#! /bin/bash

dnf update -y
dnf install python3 -y
dnf install python3-pip -y
pip3 install flask
pip3 install flask_mysql
dnf install git -y
TOKEN=${userdata-git-token}
USER=${userdata-git-name}
cd /home/ec2-user && git clone https://$TOKEN@github.com/$USER/phonebook.git
python3 /home/ec2-user/phonebook/phonebook-app.py




