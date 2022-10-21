FROM mytomcat:8.5.82-1

#COPY webapps/*.war /usr/local/tomcat/webapps

# The ojdbc_ver will depend on the version of the database. This can be updated as the database
# is updated to maintain compatibility.
ENV ojdbc_ver=19.10.0.0 \
    ojdbc_url=https://repo1.maven.org/maven2/com/oracle/database \
    tomcat_lib=/usr/local/tomcat/lib

ADD --chown=tomcat:tomcat ${ojdbc_url}/jdbc/ojdbc8/${ojdbc_ver}/ojdbc8-${ojdbc_ver}.jar ${tomcat_lib}/ojdbc8.jar
ADD --chown=tomcat:tomcat ${ojdbc_url}/xml/xdb/${ojdbc_ver}/xdb-${ojdbc_ver}.jar ${tomcat_lib}/xdb.jar
ADD --chown=tomcat:tomcat ${ojdbc_url}/jdbc/ucp/${ojdbc_ver}/ucp-${ojdbc_ver}.jar ${tomcat_lib}/ucp.jar

ENV TCDS_BP_USER="banproxy" \
    TCDS_BP_JDBC_URL="jdbc:oracle:thin:@host:port/dbservice" \
    TCDS_BP_JNDI_NAME="jdbc/bannerDataSource"

ENV TCDS_SS_USER="ban_ss_user" \
    TCDS_SS_JDBC_URL="jdbc:oracle:thin:@host:port/dbservice" \
    TCDS_SS_JNDI_NAME="jdbc/bannerSsbDataSource"

ENV TOMCAT_JAVA_HOME="/usr/local/openjdk-8" \
    TOMCAT_ROOT="/usr/local/tomcat" \
    TOMCAT_JAVA_OPTS="-Djava.awt.headless=true -Duser.timezone=America/Chicago" \
    TOMCAT_CATALINA_OPTS="-Xms2G -Xmx4G -Doracle.jdbc.autoCommitSpecCompliant=false -Dbanner.logging.dir=/app_logs -Djava.security.egd=file:/dev/../dev/urandom -server -XX:+UseParallelGC"

COPY --chown=tomcat:tomcat templates /tmp/
COPY --chown=tomcat:tomcat run.sh /run.sh

RUN chmod +x /run.sh 

SHELL ["/bin/bash", "-c"]

EXPOSE 8080

CMD /run.sh

