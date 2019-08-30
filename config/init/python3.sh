#!/bin/sh

cd /home/dockweb/python3 &
pip3 install --upgrade pip gixy virtualenv pipenv &
virtualenv /home/dockweb/python3 &
source /home/dockweb/python3/bin/activate &
pipenv install requests



"$@"
