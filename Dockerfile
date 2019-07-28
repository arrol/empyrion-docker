FROM ubuntu:bionic

RUN export DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y tar unzip curl xz-utils gnupg2 software-properties-common xvfb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN curl -s https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
RUN apt-get install -y wine-staging winetricks
RUN rm -rf /var/lib/apt/lists/*
RUN ln -s '/home/user/Steam/steamapps/common/Empyrion/' /server

# Run commands as the steam user
RUN adduser \
	--disabled-login \
	--shell /bin/bash \
	--gecos "" \
	steam
# Add to sudo group
RUN usermod -a -G sudo steam

USER steam
ENV HOME /home/user
WORKDIR /home/user
VOLUME /home/user/Steam

RUN sudo curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz
RUN chmod 777 ./steamcmd.sh
RUN ./steamcmd.sh +login anonymous +quit
RUN chmod 777 /home/Steam

EXPOSE 30000/udp
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
