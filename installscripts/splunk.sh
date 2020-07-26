#!/bin/bash
echo "#Will Start creating user - Splunk" &>>/opt/splunkinstall.log

# Downloading  Splunk tar file#
echo "#Installing Splunk enterprise 8.0.5" &>>/opt/splunkinstall.log
echo "#Downloading  Splunk tar file to /opt location" &>>/opt/splunkinstall.log
wget -O splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.5&product=splunk&filename=splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz&wget=true' &>>/opt/splunkinstall.log
tar -xzf splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz -C /opt/ 
echo "#Starting Splunk and accepting license and user - admin will be created" &>>/opt/splunkinstall.log
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd India@543 &>>/opt/splunkinstall.log
echo "#Enabling Boot Start for Splunk" &>>/opt/splunkinstall.log
/opt/splunk/bin/splunk enable boot-start &>>/opt/splunkinstall.log
echo "#Checking for Splunk Status" &>>/opt/splunkinstall.log
/opt/splunk/bin/splunk status &>>/opt/splunkinstall.log
echo "#Removing Splunk installation file" &>>/opt/splunkinstall.log
rm splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz
echo "#Verifying the server name from  Splunk install" &>>/opt/splunkinstall.log
cat /opt/splunk/etc/system/local/server.conf  | head -n 2 &>>/opt/splunkinstall.log



# Am i Root user?
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi