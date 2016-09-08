#!/usr/bin/env python3

import os
import subprocess
import sys
import argparse
import mylibs.nginx
import mylibs.system


###########################################################
# Definition of a class for the information contained in
# .mvprc
#
###########################################################

#class mvprc():
#    WorkDirectory=UserHome+"/mvp-demo"
#    ProjectName="mvp"
#    EdgeUrl="https://github.com/arocks/edge/archive/master.zip"
#    CMS1PUrl="https://github.com/jcda/djangocms-onepage-template/archive/master.zip"
#    CMSUrl="https://github.com/jcda/djangocms-template/archive/master.zip"
#    PypiUrl="https://bootstrap.pypa.io/ez_setup.py"
#    InstallCmd="sudo apt-get install"
#    AdminEmail="root@localhost.localdomain"
 

#def params_declaration():
#    return

###########################################################
# packages required by debian8 
#

Packages_List = " tmux python exim4 python3-dev fail2ban mutt logwatch python3.4-venv libjpeg-dev zlib1g-dev sqlite3 curl "

InstallPackageCommand = "sudo apt-get install"

############################################################
# Menu Options for the arg parse
#
# The method might be a bit tidious, but i am trying to keep all this readable
# and easily updatable by someone else

MenuOptions= [ 
    ("os", "os_package_install()", "installation of all the OS requirements"),
    ("virtual", "virt_env_install()", "installation of the virtual environment in the work directory"),
    ("pip", "pip_install()", "installation of the latest version of pip in the virtual environment"),
    ("uwsgi", "uwsgi_install_setup()", " installation of the uwsgi service for the project"),
    ("django", "django_install()", "installation of django in the virtual environment"),
    ("edge", "django_edge_dev_install()", "installation of a django project with the use of the edge template"),
    ("nginx", "nginx_install()", " installation and setup of the service project "),
    ("postgres", "install_postgresql()", " setup and configuration of the postgresql dbase"),
    ("help", "display_help()", " display help"),
    ("test", "run_test_server()", "run a local server on the port 8000 for verification"),
    ("superuser", "create_superuser()", "create a superuser for the django admin interface"),
    ("nuke", "nuke_project()", "erase everything"),
    ("cms", "cms", "install a djangoCMS project"),
    ("cms1p", "cms1p", "install a DjangoCMS as a one page project a la wordpress"),
    ]
 
    ######################################################################################
    # getting all the options of the table in the argparser this hould help for clarity
    #
Choices = []
Descriptions = []
InvokeFunction = []
for Option in MenuOptions:
    Choices.append(Option[0])
    Descriptions.append(Option[2])
    InvokeFunction.append(Option[1])

   
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
    WorkDirectory=os.path.join(UserHome+'/mvp-demo')
    ProjectName="mvp"
    EdgeUrl="https://github.com/arocks/edge/archive/master.zip"
    CMS1PUrl="https://github.com/jcda/djangocms-onepage-template/archive/master.zip"
    CMSUrl="https://github.com/jcda/djangocms-template/archive/master.zip"
    PypiUrl="https://bootstrap.pypa.io/ez_setup.py"
    InstallCmd="sudo apt-get install"
    AdminEmail="root@localhost.localdomain"
   
    file = open(ConfFile,"w")

###########################################################
def display_help():
    return

###########################################################
def call_env_vars():
    subprocess.call(["ls"," -a"])

###########################################################
def display_help():
    return

###########################################################
def uwsgi_install_setup():
    return

###########################################################
def run_test_server():
    return

      
###########################################################
def create_superuser():
    return


###########################################################
def nuke_project():
    return



def menu():
    return


def main():
    call_env_vars()
    
    if len(argv) < 2:
        sys.stderr.write("Usage: %s <database>" % (argv[0],))
        return 1

    if not os.path.exists(argv[1]):
        sys.stderr.write("ERROR: Database %r was not found!" % (argv[1],))
        return 1
#
#

#if __name__ == "__main__":

parser = argparse.ArgumentParser(description='Installs a django framework partially or completely.')
#parser.add_argument('action', choices=['os','virtualenv','pip','django','cms1','cms','nginx','postgresql','createsuperuser','test-site','nuke'],required=True)
parser.add_argument('-f', help = ' for a different configuration file', action = 'store')
for Option in MenuOptions:
    parser.add_argument( Option[0],  help = Option[2], action = Option[1] )

#parser.add_argument('action', choices=Choices, required=True,help=Descriptions, action=InvokeFunction)
#parser.add_argument('--file', dest='conf_file', action='store_conf', const=sum, default=none, help='get the configuration from a different file from the default .mvprc')
#sys.exit(main(sys.argv))



