#!/bin/bash
###############################################################################
# Add New User Script                                                         #
# GW/DB GW                                                                    #
###############################################################################
echo -n "Enter the values of variables 'var1' "
echo -n "(separated by a space or tab): "
read var1

#gateway information
USER=vagrant
GATEWAY=192.168.22.70

#variable check
if [ "${var1}" = "" ]; then
 echo "empty variable"
 exit
else

###GW
#password
 dbpw=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1 | sort | uniq`
 echo "------------------------------"
 echo "$var1 password set $dbpw"
 echo "------------------------------"

###DB GW
#Add user
 PW="vagrant"
 SUPW="vagrant"
 expect -c "
 set timeout 5
 spawn env LANG=C /usr/bin/ssh $USER@$GATEWAY
 expect \"password:\"
 send \"${PW}\n\"
 expect \"$\"
 send \"su -\n\"
 expect \"password:\"
 send \"${PW}\n\"
 send \"/usr/sbin/useradd $var1\n\"
 send \"id $var1\n\"
 send \"passwd $var1\n\"
 expect \"New password:\"
 send \"$dbpw\n\"
 expect \"new password:\"
 send \"$dbpw\n\"
 expect \"#\"
 send \"exit\n\"
 "
fi
