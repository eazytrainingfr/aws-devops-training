#!/bin/bash

# Update PATH
PATH=$PATH:/usr/local/bin/
yum install python3-pip -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
pip3 install git-remote-codecommit
rm -Rf alpinehelloworld || echo "folder already deleted"
rm -Rf /root/deployment || echo "folder already deleted"
git clone codecommit::us-east-1://alpinehelloworld
