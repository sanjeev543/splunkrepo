#!/bin/bash
# Splunk UF installation Script
# Created 08-14-2020
# version 1.0
# Variables
echo " Please choose Splunk Environment from TAS or TIM"
read ENV
echo " Please choose application environment from DEV,TST or PROD"
read APP
touch /opt/splunkinstall.log
install_log_file="/opt/splunkinstall.log"
tas_dev_ds=""
tas_tst_ds=""
tas_prod_ds=""
tim_dev_ds=""
tim_tst_ds=""
tim_prod_ds=""

# Checking if Splunk Universal forwarder already exists

if [ ! -d /opt/splunkforwarder/ ]
then
    echo " Splunk directory exists, stopping Splunk" &>>$install_log_file
    /opt/splunkforwarder/bin/spunk stop &>>$install_log_file
fi

# Downloading Splnk UF tarball
if [ "${ENV,,}" = "tim"]
then
    echo "#Installing Splunkenterprise 8.0.5" &>>$install_log_file
    echo "#Downloading  Splunk tar file to /opt location" &>>$install_log_file
    wget -O splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.5&product=splunk&filename=splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz&wget=true' >/dev/null 2>&1
    tar -xzf splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz -C /opt
    echo "#Starting Splunk and accepting license and user - admin will be created" &>>$install_log_file
    /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd <somepassword> &>>$install_log_file
    echo "#Enabling Boot Start for Splunk" &>>$install_log_file && /opt/splunk/bin/splunk enable boot-start &>>$install_log_file
    #Checking if depoyment client conf file already exists
    if [ -f /opt/splunkforwarder/etc/system/local/deploymentclient.conf ]; then
        echo "Deployment client config already exists!! Deleting it" &>>$install_log_file && rm -f /opt/splunkforwarder/etc/system/local/deploymentclient.conf
    fi
    echo "Configuring Deployment server" &>>$install_log_file
    if [ "${APP,,}" = "dev" ]; then
        echo " Configuring DS for EIM Dev " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tim_dev_ds:8089 &>>$install_log_file
    elif [ "${APP,,}" = "test" ]; then
        echo " Configuring DS for EIM TST " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tim_tst_ds:8089 &>>$install_log_file
    elif [ "${APP,,}" = "prod" ]; then
        echo " Configuring DS for EIM TST " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tim_prod_ds:8089 &>>$install_log_file
    else
        echo "Please Pick correct App environment from options DEV,TST or PROD" &>>$install_log_file
        exit 2
    fi
    echo "Restarting Splunk"  &>>$install_log_file && /opt/splunkforwarder/bin/splunk restart &>>$install_log_file
    echo "Checking for Splunk Status" &>>$install_log_file && /opt/splunkforwarder/bin/splunk status &>>$install_log_file
    echo "Removing Splunk tarball file" &>>$install_log_file && rm splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz
    echo "Verifying the server name from  Splunk install" &>>$install_log_file && cat /opt/splunkforwarder/etc/system/local/server.conf  | head -n 2 &>>$install_log_file
elif [ "${ENV,,}" = "tas" ]; then
    echo "Installing Splunkenterprise 8.0.5" &>>$install_log_file
    echo "Downloading  Splunk tar file to /opt location" &>>$install_log_file
    wget -O splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.5&product=splunk&filename=splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz&wget=true' >/dev/null 2>&1
    tar -xzf splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz -C $INSTALL_PATH
    echo "Starting Splunk and accepting license and user - admin will be created" &>>$install_log_file
    /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd <somepassword> &>>$install_log_file
    echo "Enabling Boot Start for Splunk" &>>$install_log_file && /opt/splunk/bin/splunk enable boot-start &>>$install_log_file
    #Checking if depoyment client conf file already exists
    if [ -f /opt/splunkforwarder/etc/system/local/deploymentclient.conf ]; then
        echo "Deployment client config already exists!! Deleting it" &>>$install_log_file && rm -f /opt/splunkforwarder/etc/system/local/deploymentclient.conf
    fi
    echo "Configuring Deployment server" &>>$install_log_file
    if [ "${APP,,}" = "dev" ]; then
        echo " Configuring DS for EIM Dev " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tas_dev_ds:8089 &>>$install_log_file
    elif [ "${APP,,}" = "test" ]; then
        echo " Configuring DS for EIM TST " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tas_tst_ds:8089 &>>$install_log_file
    elif [ "${APP,,}" = "prod" ]; then
        echo " Configuring DS for EIM TST " &>>$install_log_file && /opt/splunkforwarder/bin/splunk set deploy-poll $tas_prod_ds:8089 &>>$install_log_file
    else
        echo "Please Pick correct App environment from options DEV,TST or PROD" &>>$install_log_file
        exit 2
    fi
    echo "Restarting Splunk"  &>>$install_log_file && /opt/splunkforwarder/bin/splunk restart &>>$install_log_file
    echo "Checking for Splunk Status" &>>$install_log_file && /opt/splunkforwarder/bin/splunk status &>>$install_log_file
    echo "Removing Splunk tarball file" &>>$install_log_file && rm splunk-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz
    echo "Verifying the server name from  Splunk install" &>>$install_log_file && cat /opt/splunkforwarder/etc/system/local/server.conf  | head -n 2 &>>$install_log_file
else
    echo "Please choose Splunk environment from TAS or TIM" &>>$install_log_file
    exit 1
fi

echo "Splunk Successfully instaled!!"
exit 0