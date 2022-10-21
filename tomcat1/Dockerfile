FROM tomcat:8.5-jdk8-openjdk

ENV APP_LOGS=/app_logs

RUN rm -Rf $CATALINA_HOME/webapps.dist \
 && mkdir -p $APP_LOGS \
 && apt-get update -y  \
 && apt-get upgrade -y \
 && apt-get install -y python3-pip locales xtail gawk \
 && apt-get remove -y build-essential subversion mercurial git openssh-client 'libfreetype*' curl \
 && apt-get purge -y openssh-client \
 && apt-get clean autoclean -y \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

### Locale support for en_US.UTF-8 according to Ellucian Article 000009690
RUN touch /usr/share/locale/locale.alias \
 && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
 && locale-gen
 
ENV LANG en_US.UTF-8 \
    LANGUAGE en_US:en \
    LC_ALL en_US.UTF-8
### Locale support END ###

RUN groupadd -r -g 10001 tomcat \
 && useradd -rm -g tomcat -s /bin/bash -u 10000 tomcat \
 && chgrp -R tomcat $CATALINA_HOME \
 && chmod -R g-w $CATALINA_HOME \
 && chmod -R g+rX $CATALINA_HOME \
 && cd $CATALINA_HOME \
 && touch bin/setenv.sh \
 && mkdir -p logs temp webapps work conf \
 && chown -R tomcat bin logs temp webapps work conf $APP_LOGS \
 && ln -sf /usr/share/zoneinfo/US/Central /etc/localtime

USER tomcat

EXPOSE 8080