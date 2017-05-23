# Base on latest CentOS image
FROM centos:latest
MAINTAINER Jonathan Ervine <jon.ervine@gmail.com>
ENV container docker

# Install updates and enable EPEL and nux-desktop repositories for rtorrent and rutorrent pre-requisites
RUN yum update -y
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN curl http://negativo17.org/repos/epel-rar.repo -o /etc/yum.repos.d/epel-rar.repo
RUN yum install -y rtorrent httpd php unzip unrar mediainfo ffmpeg; yum clean all

RUN curl -L https://github.com/Novik/ruTorrent/archive/master.zip -o /rutorrent.zip
RUN unzip /rutorrent.zip
RUN rm -f /rutorrent.zip

RUN chown -R apache:apache /ruTorrent-master/share/torrents
RUN chown -R apache:apache /ruTorrent-master/share/settings

ADD rutorrent.conf /etc/httpd/conf.d/rutorrent.conf
ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80 443 5000

VOLUME /config
VOLUME /downloads

CMD ["/start.sh"]
