FROM debian:bookworm-slim

RUN export DEBIAN_FRONTEND noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests net-tools tar unzip curl xvfb locales ca-certificates lib32gcc-s1 wine64 && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen && \
    rm -rf /var/lib/apt/lists/*
RUN ln -s '/home/user/Steam/steamapps/common/Empyrion - Dedicated Server/' /server && \
    mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    useradd -m user

USER user
ENV HOME=/home/user
WORKDIR /home/user

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz
# Get's killed at the end
RUN ./steamcmd.sh +login anonymous +quit || :

EXPOSE 30000/udp
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
