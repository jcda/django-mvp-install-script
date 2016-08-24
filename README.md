# Originally this project was a presentation and a demo
now it's a tool to deploy a Django framework with 
nginx server, postgresql database on a Debian Linux distribution

as became bigger and bigger, the single file script will have to be revised
some time in the future, also, the simple use of Bash will have to be
re-thought later.

#pre-requisites: a debian 8 server with root access, ( please learn how to use
sudo )


# installation


# step by step use



# as said in the manual


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

   WORK_DIRECTORY   default: /home/jcda/demo
   PROJECT_NAME     default: YourProject
   EDGE_URL         default: https://github.com/arocks/edge/archive/master.zip
   PYPI_URL         default: https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
   INSTALL_CMD      default: "sudo apt-get install"
   ADMIN_EMAIL      default:"root@localhost.localdomain"

