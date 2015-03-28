#!/bin/bash

###########################################################
#   Installation script for  the full framework           #
#                                                         #
# steps followed :                                        #
#                                                         #
# 1: Declaration of the environment variables             #
#                                                         #
# 2: installation of the desired os packages              #
#                                                         #
# 3: installation of the python virtual environment       #
#      a. installation of pip                             #
#      b. installation of django                          #
#      c. installation of uwsgi                           #
#                                                         #
# 4: installation of django then the edge framework       #
#      a. installation of the packages                    #
#      b. migration of the sqlite database                #
#      c. creation of a superuser account                 #
#                                                         #
# 5: installation of nginx                                #
#                                                         #
# note: some part of this project will be taken from      #
# my other github repo                                    #
# https://github.com/jcda/django-scripts/                 #
# please do not hesitate to create tickets on             #
# https://github.com/jcda/mvp-notes/issues                #
#                                                         #
# usage : django-mvp-install.sh [dev,proj]                #
# no option will give a full installation with the steps  #
# 2,3,4,5 executed                                        #
# dev will execute the setps 3 and 4                      #
# proj will execute the step 4 only                       #
#                                                         #
# some part of this project are interactive               #
# as you are asked for passwords                          #
###########################################################

###########################################################
# 1: Declaration of the environment variables             #
###########################################################

export WORK_DIRECTORY = /home/ubuntu
export PROJECT_NAME = YourProject
export EDGE_URL = https://github.com/arocks/edge/archive/master.zip
export PYPI_URL = https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
export INSTALL_CMD = "sudo apt-get install"
export ADMIN_EMAIL =

###########################################################
# 2: installation of the desired os packages              #
###########################################################
os_package_install(){
INSTALL_CMD tmux python exim python3-dev fail2ban mutt logwatch

###########################################################
# basic setup of fail2ban to be added here                #
###########################################################

###########################################################
# adding your address to the forwarded users for reports  #
###########################################################



}
###########################################################
# 3: installation of the python virtual environment       #
###########################################################

virt_env_install(){

/usr/bin/pyvenv-3.4 $PROJECT_NAME --without-pip
cd $PROJECT_NAME
source $PROJECT_NAME/bin/activate

}

###########################################################
#    3.a. installation of pip                             #
###########################################################

pip_install(){

curl -O $PYPI_URL
tar -xzf setuptools-1.1.6.tar.gz
bin/python setuptools-1.1.6/ez_setup.py
easy_install pip

}

###########################################################
#    3.b. installation of django                          #
###########################################################

django_install(){

pip install django

}

###########################################################
#    3.c. installation of uwsgi                           #
###########################################################

uwsgi_install_setup(){
pip install uwsgi

# add a script in /etc/init/ with the path to the wsgi
# file in the $PROJECT DIRECTORY

}

###########################################################
# 4: installation of django then the edge framework       #
###########################################################

django_edge_install(){
cd $WORK_DIRECTORY
pip install django
django-admin.py startproject --template=$EDGE_URL --extension=py,md,html,env $PROJECT_NAME
###########################################################
#    4.a. installation of the packages                    #
###########################################################
cd $PROJECT_NAME
pip install -r requirements.txt
###########################################################
#    4.b. migration of the sqlite database                #
###########################################################
cd src
python manage.py migrate
###########################################################
#    4.c. creation of a superuser account                 #
###########################################################

}

###########################################################
# 5: installation of nginx                                #
###########################################################
nginx_install(){
$INSTALL_CMD nginx

###########################################################
# setup of a Firewall configuration letting the ports     #
# 80, 443, and 22 opened to the outside world             #
###########################################################

###########################################################
#    removal of the default server from active confs      #
###########################################################

###########################################################
#    creation of the new conf file in the available confs #
###########################################################


}

###########################################################
# Main execution                                          #
###########################################################

