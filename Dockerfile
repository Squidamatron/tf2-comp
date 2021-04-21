FROM i386/debian:buster-slim

MAINTAINER "Squidamatron"

RUN apt-get -y update \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install libstdc++6 libcurl3-gnutls curl wget libncurses5 bzip2 unzip vim file jq \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER steam 
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN useradd -ms /bin/bash "${USER}"

USER "${USER}"
WORKDIR "${HOMEDIR}"

ENV STEAMAPPID 232250
ENV STEAMAPP tf
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

RUN mkdir -p "${STEAMCMDDIR}"
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar xvzf - -C "${STEAMCMDDIR}"

ADD tf2_ds.txt update.sh clean.sh "${HOMEDIR}/"

RUN "${HOMEDIR}/update.sh" && "${HOMEDIR}/clean.sh"

EXPOSE 27015/tcp \
	27015/udp \
	27020/udp

ENV STV_PW="changeme" \
	HOSTNAME="TF2 Server" \
	STV_NAME="SourceTV" \
	SV_PW="changeme" \
	RCON_PW="changeme" \
	START_MAP="cp_process_final" \
	MAX_PLAYERS="16" \
	CONFIG="" \
	METAMOD_VERSION="1.10" \
	SOURCEMOD_VERSION="1.10" \
	UPDATE_XM="0" \
	UPDATE_CFGS="0" \
	UPDATE_PLUGINS="0" \
	LOGSTF_APIKEY="" \
	DEMOSTF_APIKEY=""

ADD plugins.sh tf.sh server.cfg "${HOMEDIR}/"
RUN "${HOMEDIR}/plugins.sh"

WORKDIR "${HOMEDIR}"

CMD ["bash", "tf.sh"]
