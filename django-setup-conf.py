#!/usr/bin/env python3

import os
import subprocess
import sys
import argparse


###########################################################
# Definition of a class for the information contained in
# .mvprc
#
###########################################################

class mvprc():
    WorkDirectory=UserHome+"/mvp-demo"
    ProjectName="mvp"
    EdgeUrl="https://github.com/arocks/edge/archive/master.zip"
    CMS1PUrl="https://github.com/jcda/djangocms-onepage-template/archive/master.zip"
    CMSUrl="https://github.com/jcda/djangocms-template/archive/master.zip"
    PypiUrl="https://bootstrap.pypa.io/ez_setup.py"
    InstallCmd="sudo apt-get install"
    AdminEmail="root@localhost.localdomain"
    return
 

def params_declaration():

###########################################################
# packages required by debian8 
#

Packages_List = " tmux python exim4 python3-dev fail2ban mutt logwatch python3.4-venv libjpeg-dev zlib1g-dev sqlite3 curl "

InstallPackageCommand = "sudo apt-get install"

############################################################
# Menu Options for the arg parse
#

MenuOptions= " {
    "os": "os_package_install()":"installation of all the OS requirements",
    "virtual":"virt_env_install()":"installation of the virtual environment in the work directory",
    "pip":"pip_install()":"installation of the latest version of pip in the virtual environment",
    "uwsgi":"uwsgi_install_setup()":" installation of the uwsgi service for the project",
    "django":"django_install()":"installation of django in the virtual environment",
    "edge":"django_edge_dev_install()":"installation of a django project with the use of the edge template",
    "nginx":"nginx_install()":" installation and setup of the service project ",
    "postgres":"install_postgresql()":" setup and configuration of the postgresql dbase",
    "help":"display_help()":" display help",
    "test":"run_test_server()":"run a local server on the port 8000 for verification",
    "superuser":"create_superuser()":"create a superuser for the django admin interface",
    "nuke":"nuke_project()":"erase everything",
    "cms":"cms":"install a djangoCMS project",
    "cms1p":"cms1p":"install a DjangoCMS as a one page project a la wordpress",
    }
    
###########################################################
# Detect if ~/.mvprc exists if it doesnt, create the file 
# and exit with an error message
#
# if it does open it and double check the values

UserHome=os.path.expanduser('~')
DefaultConfFile=os.path.join(UserHome+'/.mvprc')

###########################################################
# if a ConfFile is passed as parameter use it, otherwise rename 
#DefaultConfFile as ConfFile
ConfFile = DefaultConfFile
if os.path.isfile(ConfFile):
    file = open(ConfFile,"r")
    #######################################################
    # test if the structure is correct and contains data
    #######################################################
      
else:
    WorkDirectory=UserHome+"/mvp-demo"
    ProjectName="mvp"
    EdgeUrl="https://github.com/arocks/edge/archive/master.zip"
    CMS1PUrl="https://github.com/jcda/djangocms-onepage-template/archive/master.zip"
    CMSUrl="https://github.com/jcda/djangocms-template/archive/master.zip"
    PypiUrl="https://bootstrap.pypa.io/ez_setup.py"
    InstallCmd="sudo apt-get install"
    AdminEmail="root@localhost.localdomain"
   
    file = open(ConfFile,"w")


test_functions()
    import django-setup-test as test
    test
 

def display_help():
    "
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
"

    """
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
"""

def call_env_vars():
    subprocess.call(["ls"," -a"])

def display_help():
    return

def os_package_install():
    return
     
def virt_env_install():
    return
     
def pip_install():
    return
     
def django_install():
    return
     
def django_edge_install():
    return

def uwsgi_install_setup():
    return

def nginx_install():
return

def run_test_server():
    return

      
def create_superuser():
    return


def nuke_project():
    return



def menu():
    return


def _main_():


    return
    call_env_vars()
    
    if len(argv) < 2:
        sys.stderr.write("Usage: %s <database>" % (argv[0],))
        return 1

    if not os.path.exists(argv[1]):
        sys.stderr.write("ERROR: Database %r was not found!" % (argv[1],))
        return 1
#
#

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Installs a django framework partially or completely.')
    parser.add_argument('action', choices=['os','virtualenv','pip','django','cms1','cms','nginx','postgresql','createsuperuser','test-site','nuke'],required=True)
    parser.add_argument('--file', dest='conf_file', action='store_conf',
                    const=sum, default=none,
                    help='get the configuration from a different file from the default .mvprc')

    #sys.exit(main(sys.argv))



