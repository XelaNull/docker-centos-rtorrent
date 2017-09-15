# docker-centos-rtorrent
## rtorrent with Apache and rutorrent running on CentOS 7.4
### Build Version: 3
Date of Build: 15th September 2017

The Dockerfile should intialise the CentOS image and subscribe to the EPEL, EPEL-rar, and EPEL-multimedia repositories (the last two are hosted on negativo17.org). The pre-requisites for rtorrent with rutorrent are then installed via yum.

The EPEL repositories provide:

    supervisor mediainfo libzen libmediainfo ffmpeg unrar

The rtorrent and httpd packages are installed from the standard CentOS repositories and the rutorrent web application is cloned via git from the github project page. The supervisor package provides a method to control the daemons making up the container image and contains a web front end exposed via port 9009. Default username and password for the web front end is admin:admin.

The container can be run as follows:

    docker pull jervine/docker-centos-rtorrent
    docker run -d -t --network=<optional network> --name <optional name> -h <optional hostname> -e TZ=<optional timezone> -e USER=<username to run rtorrent as> -e USERUID=<uid of username> -v /docker/config/rtorrent:/config -v <torrent download directory on host>:<torrent download directory in container> -p 56881:56881/udp -p 59995:59995 jervine/docker-centos-rtorrent

The USER and USERUID variables will be used to create an unprivileged account in the container for the media files to be owned by and to run rtorrent under. The startup.sh script will create this user and also inject the username into the user= parameter of the sonarr.ini supervisor file.

THe TZ variable allows the user to set the correct timezone for the container and should take the form "Europe/London". If no timezone is specified then UTC is used by default. The timezone is set up when the container is run. Subsequent stops and starts will not change the timezone.

If the container is removed and is set up again using docker run commands, remember to remove the .setup file so that the start.sh script will recreate the user account and set the local time correctly.

The container can be verified on the host by using:

    docker logs <container id/container name>

Please note that the SELinux permissions of the config and downloads directories may need to be changed/corrected as necessary. [Currently chcon -Rt svirt_sandbox_file_t ]
