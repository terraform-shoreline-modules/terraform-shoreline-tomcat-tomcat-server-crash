
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat Server Crash
---

Tomcat Server Crash incident type refers to a situation where the Tomcat Server, an open-source web server and servlet container, becomes unresponsive and stops functioning. This can result in a complete or partial system outage, leading to a disruption in the delivery of web applications and services. The root cause of the crash can be attributed to a variety of factors such as misconfiguration, network or hardware issues, software bugs, or excessive server load. It is critical to address this incident quickly to minimize the impact on users and restore normal system functionality.

### Parameters
```shell
export SERVER_IP="PLACEHOLDER"

export PID="PLACEHOLDER"

export PATH_TO_TOMCAT_CONFIG_FILE="PLACEHOLDER"

export MINIMUM_MEMORY_ALLOCATION="PLACEHOLDER"

export MAXIMUM_MEMORY_ALLOCATION="PLACEHOLDER"
```

## Debug

### Check if Tomcat is running
```shell
systemctl status tomcat.service
```

### Check the Tomcat logs for errors
```shell
tail -n 100 /var/log/tomcat/catalina.out
```

### Check the system logs for any related errors
```shell
dmesg | grep tomcat
```

### Check if there are any resource limitations that might be causing the crash
```shell
free -m

df -h
```

### Check the Tomcat configuration files for any errors
```shell
cat /etc/tomcat/server.xml
```

### Check the version of Java being used by Tomcat
```shell
java -version
```

### Check the installed packages for any updates that may have caused the crash
```shell
apt list --installed | grep tomcat
```

### Check for any file permission issues
```shell
ls -l /var/log/tomcat/
```

### Check if there are any firewall or networking issues
```shell
netstat -anp | grep 8080

ping ${SERVER_IP}
```

### Check for any memory leaks in the Tomcat server
```shell
jmap -heap ${PID}
```

### Check the CPU usage and load averages
```shell
top
```

## Repair

### Restart the Tomcat server to see if it comes back online.
```shell


#!/bin/bash



# Stop Tomcat server

sudo service tomcat stop



# Start Tomcat server

sudo service tomcat start


```

### Verify that there is enough memory allocated to the Tomcat server and adjust as necessary.
```shell


#!/bin/bash



# Set the path to the Tomcat server configuration file

TOMCAT_CONFIG_FILE=${PATH_TO_TOMCAT_CONFIG_FILE}



# Set the minimum and maximum memory allocation for the Tomcat server

MIN_MEM=${MINIMUM_MEMORY_ALLOCATION}

MAX_MEM=${MAXIMUM_MEMORY_ALLOCATION}



# Check the current memory allocation for the Tomcat server

CURRENT_MEM=$(grep -oP '(?<=Xmx)\d+m' $TOMCAT_CONFIG_FILE)



# If the current memory allocation is less than the minimum, adjust it to the minimum

if [[ $CURRENT_MEM -lt $MIN_MEM ]]; then

  sed -i "s/-Xmx${CURRENT_MEM}m/-Xmx${MIN_MEM}m/" $TOMCAT_CONFIG_FILE

fi



# If the current memory allocation is greater than the maximum, adjust it to the maximum

if [[ $CURRENT_MEM -gt $MAX_MEM ]]; then

  sed -i "s/-Xmx${CURRENT_MEM}m/-Xmx${MAX_MEM}m/" $TOMCAT_CONFIG_FILE

fi



echo "Tomcat server memory allocation has been adjusted."


```