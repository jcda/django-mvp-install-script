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

if [ -f ~/.mvprc ]; then
source ~/.mvprc
else
echo "No .mvprc file in your home directory, one will be created with the default values";
echo " Feel free to modify the data. ";
echo "
export WORK_DIRECTORY=$HOME/demo
export PROJECT_NAME=YourProject
export EDGE_URL=https://github.com/arocks/edge/archive/master.zip
export PYPI_URL=https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
export INSTALL_CMD=\"sudo apt-get install\"
export ADMIN_EMAIL=\"root@localhost.localdomain\"
">> ~/.mvprc ;
 exit
fi

###########################################################
# 1.a: basic sanity check for work directory and project  #
# directory                                               #
###########################################################

if [ -d "$WORK_DIRECTORY/$PROJECT_NAME" ]; then
  mkdir -p "$WORK_DIRECTORY/$PROJECT_NAME"
fi

###########################################################
# 2: installation of the desired os packages              #
###########################################################

os_package_install(){
exec $INSTALL_CMD tmux python exim4 python3-dev fail2ban mutt logwatch python3.4-venv libjpeg-dev zlib1g-dev sqlite3

###########################################################
# basic setup of fail2ban to be added here                #
###########################################################

###########################################################
# adding your address to the forwarded users for reports  #
###########################################################


echo "Package install Done"
}

###########################################################
# 3: installation of the python virtual environment       #
###########################################################

virt_env_install(){
cd $WORK_DIRECTORY
/usr/bin/pyvenv-3.4 $PROJECT_NAME --without-pip
cd $PROJECT_NAME
source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate

echo "Python virtual environment installed"
}

###########################################################
#    3.a. installation of pip                             #
###########################################################

pip_install(){

source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
cd $WORK_DIRECTORY/$PROJECT_NAME
#curl -O $PYPI_URL
#tar -xzf setuptools-1.1.6.tar.gz
#bin/python setuptools-1.1.6/ez_setup.py
curl https://bootstrap.pypa.io/ez_setup.py -o - | python
easy_install pip

echo "Pip installation done"
}

###########################################################
#    3.b. installation of django                          #
###########################################################

django_install(){

source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
pip install Django

echo "Django framework installed"
}

###########################################################
#    3.c. installation of uwsgi                           #
###########################################################

uwsgi_install_setup(){
source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
pip install uwsgi

# add a script in /etc/init/ with the path to the wsgi
# file in the $PROJECT DIRECTORY

sudo sh -c "echo '

description "uWSGI"
start on runlevel [2345]
stop on runlevel [06]

respawn

# this is to get the full environment created by virtualenv
#source "$WORK_DIRECTORY"/"$PROJECT_NAME"/bin/activate

#env UWSGI=/usr/local/bin/uwsgi
env UWSGI='$WORK_DIRECTORY'/'$PROJECT_NAME'/bin/uwsgi
env LOGTO=/var/log/uwsgi-emperor.log
env SOCKET=127.0.0.1:3031
#env SOCKET=/tmp/uwsgi.sock
#env chmod-socket = 664

#the first attempt was from a website http://grokcode.com/784/how-to-setup-a-linux-nginx-uwsgi-python-django-server/

exec \$UWSGI --chdir='$WORK_DIRECTORY'/'$PROJECT_NAME'/'$PROJECT_NAME'/src/ --env DJANGO_SETTINGS_MODULE='$PROJECT_NAME'.settings --master --socket=\$SOCKET --processes=5 --vacuum --virtualenv='$WORK_DIRECTORY'/'$PROJECT_NAME' --module '$PROJECT_NAME'.wsgi --logto \$LOGTO

' > /etc/init/uwsgi.conf"


# to start the whole framework without having to reboot
sudo service uwsgi start && service nginx restart

echo "uwsgi an nginx services installed"
}


###########################################################
# 4: installation of django then the edge framework       #
###########################################################

django_edge_install(){
source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
cd $WORK_DIRECTORY/$PROJECT_NAME
django-admin.py startproject --template=$EDGE_URL --extension=py,md,html,env $PROJECT_NAME

###########################################################
#         installation of the packages                    #
###########################################################

cd $PROJECT_NAME
pip install -r requirements.txt

##########################################################
#        installation of the local.env specific to this  #
#    server                                              #
##########################################################

echo " installation of the local.env file in settings"
cp $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src/$PROJECT_NAME/settings/local.sample.env $WORK_DIRECTORY/$WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src/$PROJECT_NAME/settings/local.env

###########################################################
#         migration of the sqlite database                #
###########################################################

cd src
python manage.py migrate

###########################################################
#         creation of a superuser account                 #
###########################################################


echo "django edge installed"
echo "now you need to create a superuser account "
}


###########################################################
# 5: installation of nginx                                #
###########################################################

nginx_install(){

#exec $INSTALL_CMD nginx

sudo sh -c "echo '
server {
    listen          80;
    server_name     roo.red www.roo.red;
    access_log /var/log/nginx/access.log;
    error_log /var/log/error.log;

    location /static {
        alias '$WORK_DIRECTORY'/'$PROJECT_NAME'/'$PROJECT_NAME'/src/static;
    }
    #error_page   404              /404.html;
    #error_page   500 502 503 504  /50x.html;
    #location = /50x.html {
    #    root   /usr/share/nginx/html;
    #}
    location / {
        uwsgi_pass 127.0.0.1:3031;
        include         uwsgi_params;
    }

     location /itempics {
         alias /var/www/'$PROJECT_NAME'/itempics;
    }
}

'>/etc/nginx/sites-available/$PROJECT_NAME.conf"

#to activate this nginx configuration, this needs to be done
sudo ln  /etc/nginx/sites-available/$PROJECT_NAME.conf /etc/nginx/sites-enabled/$PROJECT_NAME.conf
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

echo "nginx setup done"
}

###########################################################
# Install and configuration of Postgresql for production
###########################################################

install_postgresql(){

#
# Installation of the packages
#
# sudo apt-get install postgresql

#
# creation of the database
#

# using https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-django-with-postgres-nginx-and-gunicorn
# for reference
# sudo su - postgres
# createdb mydb
# createuser -P
## 6 questions prompted here
# psql
# GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
#

#
# configuration the setup.py to point towards the local DATABASE
#


echo "temporary dummy"
echo "Postgresql installation and setup done"
}
###########################################################
# Help page                                               #
###########################################################
display_help(){
echo "
NAME
    django-mvp-install.sh installs a webserver and a complete
turn-key framework automagically
SYNOPSIS
    django-mvp-install.sh [OPTION]
DESCRIPTION
    all : install the whole shebang following the path defined in the script
    for development purpose, the database used is sqlite in thie s case,
    but can be transfered to postgresql later on
    all-production : installs the whole shebang usiting postgresql as database
    os : install all the components required from the OS side
    virtualenv : create a chrooted environment for the python project
     that doesnt impact on the rest of the server configuration
    pip : installs a separated pip for the virtual ENVIRONMENT
    django : install django in the separated virtual environment previously
    created
    edge : installs the django template edge
    nginx : setups the nginx http server
    uwsgi : setups uwsgi to work with nginx

ENVIRONMENT
    on the first run of this script, a .mvprc file is created in the
    home directory of the user it contains the default variables used
    by the script this will work out of the box with the default variables, but
    you should personalize them.

   WORK_DIRECTORY   default: $HOME/demo
   PROJECT_NAME     default: YourProject
   EDGE_URL         default: https://github.com/arocks/edge/archive/master.zip
   PYPI_URL         default: https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
   INSTALL_CMD      default: \"sudo apt-get install\"
   ADMIN_EMAIL      default:\"root@localhost.localdomain\"
"

}


###########################################################
# Main execution                                          #
###########################################################


# test of directories
#if [ -d $WORK_DIRECTORY ]
#    mkdir WORK_DIRECTORY
#fi

#echo "command " $1 "will be processed"
case $1 in
  "")
     display_help;;
     #os_package_install;
     #virt_env_install;
     #pip_install;
     #django_install;
     #django_edge_install;
     #uwsgi_install_setup;
     #nginx_install;
  "all")
     os_package_install;
     virt_env_install;
     pip_install;
     django_install;
     django_edge_install;
     uwsgi_install_setup;
     nginx_install;;
   "all-prod")
     os_package_install;
     virt_env_install;
     pip_install;
     django_install;
     django_edge_install;
     uwsgi_install_setup;
     nginx_install;;
   "os")
     os_package_install;;
   "virtualenv")
     virt_env_install;;
   "pip")
     pip_install;;
   "django")
     django_install;;
   "edge")
     django_edge_install;;
   "uwsgi")
     uwsgi_install_setup;;
   "nginx")
     nginx_install;;
   "nuke")
     echo "you don't want to do that ... not yet";;
esac
