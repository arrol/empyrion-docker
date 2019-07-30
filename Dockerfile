FROM arrol/uwine:latest
RUN apt-get install -y sudo
# Run commands as the steam user
RUN adduser --disabled-login --shell /bin/bash --gecos "" steam
# Add to sudo group
RUN usermod -a -G sudo steam
WORKDIR /home/steam
ADD entrypoint.sh .
RUN mkdir empyrion
RUN chown -R steam:steam .
RUN chmod 700 ./entrypoint.sh
VOLUME /home/steam/empyrion
USER steam
ENV HOME /home/steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz
RUN ./steamcmd.sh +login anonymous +quit

EXPOSE 30000/udp
ENTRYPOINT ["./entrypoint.sh"]