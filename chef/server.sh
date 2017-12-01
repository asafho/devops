#!bin/sh
set -e

#doc https://docs.chef.io/install_chef_automate.html
#download site  http://downloads.chef.io/chef-server

USERNAME=admin
FirstName=admin
LastName=admin
EMAIL=admin@admin.com
PASSWORD=admin123 #Password must have at least 6 characters
ORGNAME=admin #short_name
ORGFULLNAME="admin organization" #full_organization_name

if [ -f /etc/debian_version ]; then
   echo "install chef server on debian"
   apt-get update
   wget https://packages.chef.io/files/stable/chef-server/12.15.8/ubuntu/16.04/chef-server-core_12.15.8-1_amd64.deb
   dpkg -i chef-server-core_12.15.8-1_amd64.deb
   rm chef-server-core_12.15.8-1_amd64.deb
elif [ -f /etc/redhat-release ]; then
   echo "install chef server on centos"
   yum install wget
   wget https://packages.chef.io/files/stable/chef-server/12.15.8/el/7/chef-server-core-12.15.8-1.el7.x86_64.rpm
   sudo rpm -Uvh chef-server-core-12.15.8-1.el7.x86_64.rpm
   rm chef-server-core-12.15.8-1.el7.x86_64.rpm
fi

chef-server-ctl reconfigure
cd ~
echo "install and configure chef server"
mkdir -p .pems
chef-server-ctl user-create $USERNAME $FirstName $LastName $EMAIL $PASSWORD --filename .pems/$USERNAME.pem
#chef-server-ctl org-create short_name 'full_organization_name' --association_user user_name --filename ORGANIZATION-validator.pem
chef-server-ctl org-create $ORGNAME '$ORGFULLNAME' --association_user $USERNAME --filename .pems/$ORGNAME-validator.pem



echo “install submudols”
chef-server-ctl install chef-manage
chef-server-ctl install opscode-push-jobs-server
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure

chef-manage-ctl reconfigure --accept-license
opscode-push-jobs-server-ctl reconfigure
opscode-reporting-ctl reconfigure