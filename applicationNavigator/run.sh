#!/bin/bash

die () {
        echo "ERROR: $*"
        exit 1
}
#
# Backup files
#
for file in server.xml context.xml 
do
  cp /usr/local/tomcat/conf/$file /usr/local/tomcat/conf/${file}_$(date '+%Y-%m-%d') || die "Error backing up $file"
  cp /usr/local/tomcat/conf/$file /tmp/$file || die "Error prepping file $file for update"
done

#
# Gather Tomcat Datasource variable information
#
read -d "\n" -a ds_array <<< `env |grep "JNDI_NAME"|awk '{print $1}'`
for var in "${ds_array[@]}"
do
  varname=`echo "$var"|awk -F= '{print $1}'`
  varvalue=`echo "$var"|awk -F= '{print $2}'`
  varprefix=`echo "$var"|sed 's/TCDS_//'|sed 's/_.*//'`

  uservar="TCDS_${varprefix}_USER"
  jndivar="TCDS_${varprefix}_JNDI_NAME"
  urlvar="TCDS_${varprefix}_JDBC_URL"
  pswdvar="TCDS_${varprefix}_PASSWORD"

#
# Update server.xml
#
  if [[ -f "/tmp/resource_${varprefix}.sed" ]]; then
     rm /tmp/resource_${varprefix}.sed
  fi
  cat <<EOF > /tmp/resource_${varprefix}.sed
s|jdbcDatasource|${!jndivar}|
s|jdbcUrl|${!urlvar}|
s|datasourceUser|${!uservar}|
s|datasourcePswd|${!pswdvar}|
EOF

  sed -f /tmp/resource_${varprefix}.sed /tmp/resource.xml >/tmp/resource_${varprefix}.xml
  sed -i '/<\/GlobalNamingResources>/e cat /tmp/resource_'"${varprefix}"'.xml' /tmp/server.xml || die "Error updating server.xml"

#
# Update context.xml
#
  if [[ -f "/tmp/resourceLink_${varprefix}.sed" ]]; then
     rm /tmp/resourceLink_${varprefix}.sed
  fi
  cat <<EOF >> /tmp/resourceLink_${varprefix}.sed 
s|jdbcDatasource|${!jndivar}|g
EOF

  sed -f /tmp/resourceLink_${varprefix}.sed /tmp/resourceLink.xml >/tmp/resourceLink_${varprefix}.xml
  sed -i '/<\/Context>/e cat /tmp/resourceLink_'"${varprefix}"'.xml' /tmp/context.xml || die "Error updating context.xml"

done

#
# Copy updated files back to tomcat directory
#
cp /tmp/server.xml /usr/local/tomcat/conf/server.xml || die "Error copying server.xml to tomcat directory"
cp /tmp/context.xml /usr/local/tomcat/conf/context.xml || die "Error copying context.xml to tomcat directory"

#
# Copy setenv.sh to tomcat directory
#
cp /tmp/setenv.sh /usr/local/tomcat/bin/setenv.sh || die "Error copying setenv.sh to tomcat directory"

#
# Startup tomcat
#
cd $CATALINA_HOME || die "failed to cd to CATALINA_HOME ($CATALINA_HOME)"

xtail ${APP_LOGS} &

bin/catalina.sh run