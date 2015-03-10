# Base on latest CentOS image
FROM centos:latest
MAINTAINER Jonathan Ervine <jon.ervine@gmail.com>
ENV container docker

# Install updates and enable EPEL and repoforge repositories for SABnzbd pre-requisites
RUN yum update -y
RUN yum install -y http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
RUN yum install -y rtorrent httpd php unzip unrar mediainfo ffmpeg; yum clean all

RUN curl -L https://github.com/Novik/ruTorrent/archive/master.zip -o /rutorrent.zip
RUN unzip /rutorrent.zip
RUN rm -f /rutorrent.zip

RUN chown -R apache:apache /ruTorrent-master/share/torrents
RUN chown -R apache:apache /ruTorrent-master/share/settings

ADD rutorrent.conf /etc/httpd/conf.d/rutorrent.conf
ADD httpd.passwd /etc/httpd/httpd.passwd
ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80 443 5000

VOLUME /config
VOLUME /downloads

CMD ["/start.sh"]
