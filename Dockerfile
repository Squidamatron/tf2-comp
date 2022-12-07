FROM debian:bullseye-slim

MAINTAINER "Squidamatron"

RUN dpkg --add-architecture i386 \
	&& apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
		lib32z1 \
		libncurses5:i386 \
		libbz2-1.0:i386 \
		lib32gcc-s1 \
		lib32stdc++6 \
		libtinfo5:i386 \
		libcurl3-gnutls:i386 \
		libsdl2-2.0-0:i386 \
		locales \
		curl \
		ca-certificates \
		bzip2 \
		unzip \
		vim \
		file \
		jq \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
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

RUN mkdir -p "${STEAMCMDDIR}" && curl "https://media.steampowered.com/client/steamcmd_linux.tar.gz" | tar xvzf - -C "${STEAMCMDDIR}"

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
	METAMOD_VERSION="1.11" \
	SOURCEMOD_VERSION="1.11" \
	UPDATE_XM="0" \
	UPDATE_CFGS="0" \
	UPDATE_PLUGINS="0" \
	REGION="" \
	LOGSTF_APIKEY="" \
	DEMOSTF_APIKEY=""

ADD plugins.sh tf.sh server.cfg gamejson.smx splock.smx "${HOMEDIR}/"
RUN "${HOMEDIR}/plugins.sh"

WORKDIR "${HOMEDIR}"

CMD ["bash", "tf.sh"]
