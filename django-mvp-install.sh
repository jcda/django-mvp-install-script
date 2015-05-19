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

export WORK_DIRECTORY=$HOME
export PROJECT_NAME=YourProject
export EDGE_URL=https://github.com/arocks/edge/archive/master.zip
export PYPI_URL=https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
export INSTALL_CMD="sudo apt-get install"
export ADMIN_EMAIL="root@localhost.localdomain"

###########################################################
# 2: installation of the desired os packages              #
###########################################################

os_package_install(){
exec $INSTALL_CMD tmux python exim4 python3-dev fail2ban mutt logwatch

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
curl -O $PYPI_URL
tar -xzf setuptools-1.1.6.tar.gz
bin/python setuptools-1.1.6/ez_setup.py
easy_install pip

echo "Pip installation done"
}

###########################################################
#    3.b. installation of django                          #
###########################################################

django_install(){

source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
pip install Django==1.7

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
    virtualenv
    pip
    django
    edge
    nginx
    uwsgi

ENVIRONMENT

"

}


###########################################################
# Main execution                                          #
###########################################################

echo "command " $1 "will be processed"
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
