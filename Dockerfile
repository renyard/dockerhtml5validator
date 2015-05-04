FROM ubuntu:14.04.1
MAINTAINER Ian Renyard "ian@renyard.net"

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install \
	apache2 build-essential \
	libapache2-mod-perl2 libhtml-tidy-perl libosp-dev libxml-libxml-perl libxml2-dev \
	openjdk-6-jre opensp supervisor unzip zlib1g-dev \
	curl

RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get -y install nodejs

RUN apt-get clean

RUN mkdir /root/build
ADD ./resource/apache.server.conf /etc/apache2/conf-available/server.conf
ADD ./resource/supervisord.conf /etc/supervisor/conf.d/
ADD http://validator.w3.org/validator.tar.gz /root/build/
ADD http://validator.w3.org/sgml-lib.tar.gz /root/build/
ADD https://github.com/validator/validator/releases/download/20150216/vnu-20150216.jar.zip /root/build/

ADD ./proxy.js /opt/proxy/
RUN chmod a+x /opt/proxy/proxy.js
ADD ./certs/server.crt /etc/ssl/server.crt
ADD ./certs/server.key /etc/ssl/server.key
ADD ./package.json /opt/proxy/
RUN cd /opt/proxy/ && npm install && cd -
RUN cp /opt/proxy/node_modules/newrelic/newrelic.js /opt/proxy/

ADD ./resource/configure.sh /root/build/
WORKDIR /root/build
RUN chmod a+x configure.sh
RUN ./configure.sh

RUN sh -c 'echo deb http://apt.newrelic.com/debian/ newrelic non-free > /etc/apt/sources.list.d/newrelic.list'
RUN curl -sL https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN apt-get update
RUN apt-get install newrelic-sysmond
RUN echo "To complete setup of New Relic, run:"
RUN echo "nrsysmond-config --set license_key=YOUR_LICENSE_KEY"
RUN echo "/etc/init.d/newrelic-sysmond start"
RUN echo ""
RUN echo "For the Node app monitoring, add the the licence key to /opt/proxy/newrelic.js"

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
