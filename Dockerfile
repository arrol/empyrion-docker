FROM arrol/uwine:latest

# Run commands as the steam user
RUN adduser --disabled-login --shell /bin/bash --gecos "" steam
# Add to sudo group
RUN usermod -a -G sudo steam
USER steam
ENV HOME /home/steam
VOLUME /home/steam/empyrion
WORKDIR /home/steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz

RUN chmod 777 ./steamcmd.sh

RUN ./steamcmd.sh +login anonymous +quit


EXPOSE 30000/udp
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]