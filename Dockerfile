FROM ubuntu:14.04
MAINTAINER Liso Gallo <liso@riseup.net>
ENV REFRESHED_AT 2014-12-04
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y vim ccze iptraf htop cbm ncdu elinks-lite molly-guard mc python-pip python-virtualenv facter git ack-grep
RUN apt-get install -y python-dev libldap2-dev libsasl2-dev libpq-dev libxml2-dev libxslt1-dev libfreetype6-dev libjpeg8-dev
RUN mkdir --parents /opt/odoo
RUN useradd --create-home --password odoo odoo
RUN chown --recursive odoo:odoo /opt/odoo/
USER odoo
RUN git clone https://github.com/odoo/odoo.git /opt/odoo/server
WORKDIR /opt/odoo/server/
RUN git checkout 8.0
USER root
RUN python setup.py install
RUN sudo -H -u odoo /opt/odoo/server/odoo.py --stop-after-init --save --config=/opt/odoo/odoo.conf --db_host=odoo-db --db_user=odoo --db_password=odoo
CMD ["sudo", "-H", "-u", "odoo", "/opt/odoo/server/odoo.py", "-c", "/opt/odoo/odoo.conf"]