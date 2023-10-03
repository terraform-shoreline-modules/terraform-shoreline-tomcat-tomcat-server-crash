

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