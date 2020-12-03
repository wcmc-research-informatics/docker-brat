# start from a base ubuntu image
FROM ubuntu:18.04
MAINTAINER Prakash Adekkanattu <pra2008@med.cornell.edu>

# set users cfg file
ARG USERS_CFG=users.json

# Install pre-reqs
RUN apt-get update
RUN apt-get install -y curl vim nano sudo wget rsync
RUN apt-get install -y apache2
RUN apt-get install -y python
RUN apt-get install -y supervisor
RUN apt-get update -y && \
    apt-get install -y build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev pkg-config libssl-dev mime-support automake libtool wget tar git unzip
RUN apt-get install lsb-release -y  && apt-get install zip -y && apt-get install vim -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add  brat
ADD brat /var/www/brat

# create a symlink so users can mount their data volume at /bratdata rather than the full path
RUN mkdir /bratdata && mkdir /bratcfg && mkdir /bratwork
RUN chown -R www-data:www-data /bratdata /bratcfg /bratwork
RUN chmod o-rwx /bratdata /bratcfg /bratwork
RUN ln -s /bratdata /var/www/brat/data
RUN ln -s /bratcfg /var/www/brat/cfg
RUN ln -s /bratwork /var/www/brat/work

# And make that location a volume
VOLUME /bratdata
VOLUME /bratcfg

ADD brat_install_wrapper.sh /usr/bin/brat_install_wrapper.sh
RUN chmod +x /usr/bin/brat_install_wrapper.sh

# Make sure apache can access it
RUN chown -R www-data:www-data /var/www/brat/

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

#add users to config directory
ADD users.json bratcfg/users.json
#RUN chown -R www-data:www-data /bratcfg/users.json

# add the user patch script to enable additional users for brat and set windows authentication
ADD user_patch.py /var/www/brat/user_patch.py

# Enable cgi
RUN a2enmod cgi

EXPOSE 80

## change workdir to /
WORKDIR /

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]





