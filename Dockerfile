# Base on latest CentOS image
FROM centos:latest
MAINTAINER Jonathan Ervine <jon.ervine@gmail.com>
ENV container docker

# Install updates and enable EPEL and nux-desktop repositories for rtorrent and rutorrent pre-requisites
RUN yum update -y
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN curl https://negativo17.org/repos/epel-rar.repo -o /etc/yum.repos.d/epel-rar.repo
RUN curl https://negativo17.org/repos/epel-multimedia.repo -o /etc/yum.repos.d/epel-multimedia.repo
RUN yum install -y rtorrent httpd php unzip unrar mediainfo ffmpeg git supervisor logrotate
RUN yum clean all

#RUN curl -L https://github.com/Novik/ruTorrent/archive/master.zip -o /rutorrent.zip
RUN git clone https://github.com/Novik/ruTorrent.git
#RUN unzip /rutorrent.zip
#RUN rm -f /rutorrent.zip

RUN chown -R apache:apache /ruTorrent/share/torrents
RUN chown -R apache:apache /ruTorrent/share/settings

ADD rutorrent.conf /etc/httpd/conf.d/rutorrent.conf
ADD start.sh /sbin/start.sh
ADD supervisord.conf /etc/supervisord.conf
ADD apache.ini /etc/supervisord.d/apache.ini
ADD rtorrent.ini /etc/supervisord.d/rtorrent.ini
RUN chmod 755 /sbin/start.sh

EXPOSE 80 443 5000 9009

VOLUME /config
VOLUME /downloads

CMD ["/sbin/start.sh"]
