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
# usage : django-mvp-install.sh [option]                  #
# no option will give a full installation with the steps  #
# 2,3,4,5 executed                                        #
# dev will execute the steps 3 and 4                      #
# proj will execute the step 4 only                       #
#                                                         #
# some part of this project are interactive               #
# as you are asked for passwords                          #
###########################################################

###########################################################
# short cut for activation of virtualenv                  #
###########################################################

activate(){
    source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
    cd $WORK_DIRECTORY/$PROJECT_NAME
}


###########################################################
# 1: Sanity Check and Directory creation                  #
# i  Declaration of the environment variables             #
###########################################################

if [ -f ~/.mvprc ]; then
source ~/.mvprc

    if [ ! -d "$WORK_DIRECTORY" ]; then
      echo "creating the $WORK_DIRECTORY directory"
      mkdir -p "$WORK_DIRECTORY"
    fi
    if [ ! -d "$WORK_DIRECTORY/$PROJECT_NAME" ]; then
      mkdir -p "$WORK_DIRECTORY/$PROJECT_NAME"
    fi
else
echo "No .mvprc file in your home directory, one will be created with the default values";
echo " Feel free to modify the data. ";
echo "
export WORK_DIRECTORY=$HOME/mvp-demo
export PROJECT_NAME=mvp
export EDGE_URL=https://github.com/arocks/edge/archive/master.zip
export PYPI_URL=https://bootstrap.pypa.io/ez_setup.py
export INSTALL_CMD=\"sudo apt-get install\"
export ADMIN_EMAIL=\"root@localhost.localdomain\"
">> ~/.mvprc ;
exit
fi

###########################################################
# 2: installation of the desired os packages              #
###########################################################

os_package_install(){
  $INSTALL_CMD tmux python exim4 python3-dev fail2ban mutt logwatch python3.4-venv libjpeg-dev zlib1g-dev sqlite3
  echo "package install done"

###########################################################
# basic setup of fail2ban to be added here                #
###########################################################

echo "fail2ban setup not implemented yet"

###########################################################
# adding your address to the forwarded users for reports  #
###########################################################

echo " adding admin user to emails not implemented yet"

}

###########################################################
# 3: installation of the python virtual environment       #
###########################################################

virt_env_install(){

cd $WORK_DIRECTORY
#/usr/bin/pyvenv-3.4 $PROJECT_NAME --without-pip
pyvenv-3.4 $PROJECT_NAME --without-pip
cd $PROJECT_NAME
echo "source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate"> \
$WORK_DIRECTORY/$PROJECT_NAME/.env
chmod +x $WORK_DIRECTORY/$PROJECT_NAME/.env

echo "Python virtual environment installed"
echo "virtualenv `date`" >> $WORK_DIRECTORY/$PROJECT_NAME/.log
}

###########################################################
#    3.a. installation of pip                             #
###########################################################

pip_install(){


if grep -q virtualenv $WORK_DIRECTORY/$PROJECT_NAME/.log; then
    activate
    #source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
    #cd $WORK_DIRECTORY/$PROJECT_NAME
    curl $PYPI_URL -o - | python
    easy_install pip
    echo "Pip installation done"
    echo "pip :`date`" >> $WORK_DIRECTORY/$PROJECT_NAME/.log
else
    echo "Well, this is disapointing, but virtualenv should be installed before "
    exit
fi
}

###########################################################
#    3.b. installation of django                          #
###########################################################

django_install(){

if grep -q pip $WORK_DIRECTORY/$PROJECT_NAME/.log; then
    #source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
    activate
    pip install Django

    echo "Django framework installed"
    echo "django `date`" >> $WORK_DIRECTORY/$PROJECT_NAME/.log
else
    echo "Well, this is disapointing, but pip should be installed before"
    exit
fi
}

###########################################################
#    3.c. installation of uwsgi                           #
###########################################################

uwsgi_install_setup(){

if grep -q django $WORK_DIRECTORY/$PROJECT_NAME/.log; then

activate
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

echo "uwsgi:`date`"> $WORK_DIRECTORY/$PROJECT_NAME/.log

echo "uwsgi an nginx services installed"

fi
}


###########################################################
# 4: installation of django then the edge framework       #
###########################################################

django_edge_dev_install(){
if grep -q django $WORK_DIRECTORY/$PROJECT_NAME/.log; then

   #source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
   #cd $WORK_DIRECTORY/$PROJECT_NAME
   activate
   django-admin.py startproject --template=$EDGE_URL --extension=py,md,html,env $PROJECT_NAME

   chmod +x $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src/manage.py

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
   cd $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src/$PROJECT_NAME/settings/
   cat local.sample.env | sed '/SECRET_KEY/d' > local.env
   MAGIC_KEY=`python -c 'import random; import string; print("".join([random.SystemRandom().choice(string.digits + string.ascii_letters + string.punctuation) for i in range(100)]))'`
   echo "SECRET_KEY="$MAGIC_KEY >> local.env

###########################################################
#         migration of the sqlite database                #
###########################################################

    cd $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src
    ./manage.py migrate

###########################################################
#         creation of a superuser account                 #
###########################################################


    echo "django edge installed"
    echo "now you need to create a superuser account, using the superuser option"
    echo " edge_dev `date`">> $WORK_DIRECTORY/$PROJECT_NAME/.log
else
   echo " Well, this is disappointing, but django wasnt installed beforehand "
  exit
fi
}


###########################################################
# 5: installation of nginx                                #
###########################################################

nginx_install(){

#exec $INSTALL_CMD nginx
if [ ! -d "/etc/nginx/sites-available" ]; then
  sudo sh -c "mkdir -p /etc/nginx/sites-available"
fi
if grep -q django $WORK_DIRECTORY/$PROJECT_NAME/.log; then
sudo sh -c "echo '
server {
    listen          80;
    server_name     '$HOSTNAME' localhost.localdomain;
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
echo "nginx_uwsgi:`date`" $WORK_DIRECTORY/$PROJECT_NAME/.log
fi
echo "nginx setup done"
}

###########################################################
#
###########################################################

gunicorn_nginx_setup(){

    if grep -q uwsgi $WORK_DIRECTORY/$PROJECT_NAME/.log; then
        echo "uwsgi already setup, this will conflict with the current setup"
        exit
    fi
    if grep -q django $WORK_DIRECTORY/$PROJECT_NAME/.log; then



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
    This tool is to automate the installation process of a basic django website
    the options are the following :
    - base: [meta] installs a virtual environment with the base of python 3, pip
    separated from the OS, and django. Warning: OS dependances will have to be
    installed first install Brew and Xcode on MacOSX platform or run this script
    with os as parameter.
    - all : [meta] install the whole shebang following the path defined in the script
    for development purpose, the database used is sqlite in thie s case,
    but can be transfered to postgresql later on
    - os : install all the components required from the OS side, picture
    libraries for Pillow installation, and others. ROOT PRIVILEGES ARE REQUIRED
    - virtualenv : create a chrooted environment for the python project
     that doesnt impact on the rest of the server configuration
    - pip : installs a separated pip for the virtual ENVIRONMENT.
    - django : install django in the separated virtual environment previously
    created. It requires pip to be installed
    - edge : installs the django template edge. It requires django and pip to
    be already installed
    - nginx : [under construction ] setups the nginx http server. ROOT PRIVILEGES ARE REQUIRED.
    - uwsgi : [under construction ]setups uwsgi to work with nginx. ROOT PRIVILEGES ARE REQUIRED
    - runserver : will run locally a test webserver for your tests on the port 8000
    - superuser : invokes the command to create a superuser account

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
# run the test server on the port 8000                    #
###########################################################

run_test_server(){

activate
#source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
cd $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src
./manage.py runserver

}
###########################################################
# run the command to create a superuser                   #
###########################################################

create_superuser(){

activate
#source $WORK_DIRECTORY/$PROJECT_NAME/bin/activate
cd $WORK_DIRECTORY/$PROJECT_NAME/$PROJECT_NAME/src
./manage.py createsuperuser

}

###########################################################
# Main execution                                          #
###########################################################


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
  "base")
     virt_env_install &&
     pip_install &&
     django_install &&
     django_edge_dev_install;;
  "all")
     os_package_install &&
     virt_env_install &&
     pip_install &&
     django_install &&
     django_edge_dev_install &&
     uwsgi_install_setup &&
     nginx_install;;
   "all-prod")
     os_package_install;
     virt_env_install;
     pip_install;
     django_install;
     django_edge_dev_install;
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
     django_edge_dev_install;;
   "uwsgi")
     uwsgi_install_setup;;
   "nginx")
     nginx_install;;
    "runserver")
      run_test_server;;
    "superuser")
      create_superuser;;
   "nuke")
     echo "you don't want to do that ... not yet";;
     *)
      display_help;;
esac
