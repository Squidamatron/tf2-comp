#!/bin/bash

# Update {Meta,Source}Mod
if [ "$UPDATE_XM" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating MetaMod and SourceMod..."

	# Metamod
	LATESTMM=$(wget -qO- "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/mmsource-latest-linux")
	wget -qO- "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/${LATESTMM}" | tar xzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

	# Sourcemod
	LATESTSM=$(wget -qO- "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/sourcemod-latest-linux")
	wget -qO- "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/${LATESTSM}" | tar xzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Update CFGS
if [ "$UPDATE_CFGS" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating RGL and ETF2L cfgs..."

	# RGL Server Resources
	LATESTRGL=$(curl -s https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].browser_download_url')
	RGLDL=$(curl -s https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].name')
	wget -q "$LATESTRGL"
	unzip -o -q "$RGLDL" -d "${STEAMAPPDIR}/${STEAMAPP}"
	rm "$RGLDL"

	# ETF2L CFG
	wget -q "https://etf2l.org/configs/etf2l_configs.zip"
	unzip -o -q "etf2l_configs.zip" -d "${STEAMAPPDIR}/${STEAMAPP}/cfg"
	rm "etf2l_configs.zip"
fi

# Update Plugins
if [ "$UPDATE_PLUGINS" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating plugins..."

	# SOAP-DM
	wget -q "https://github.com/sapphonie/SOAP-TF2DM/archive/master.zip" -O "soap-dm.zip"
	unzip -q "soap-dm.zip"
	cp -r SOAP-TF2DM-master/* "${STEAMAPPDIR}/${STEAMAPP}"
	rm -r "SOAP-TF2DM-master"
	rm "soap-dm.zip"

	# demos.tf
	wget -q "https://github.com/demostf/plugin/raw/master/demostf.smx" -O "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/demostf.smx"

	# F2 Plugins
	wget -q "http://sourcemod.krus.dk/f2-sourcemod-plugins.zip"
	unzip -q "f2-sourcemod-plugins.zip" -d f2
	chmod 0664 f2/*
	cp f2/{afk,logstf,medicstats,recordstv,restorescore,supstats2}.smx "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/."
	rm -r "f2"
	rm "f2-sourcemod-plugins.zip"

	# Map Downloader
	wget -q "https://github.com/nutcity/mapdownloader/raw/master/plugin/mapdownloader.smx" -O "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/mapdownloader.smx"

	# proper-pregame
	wget -q "https://github.com/nutcity/ProperPregame/raw/master/addons/sourcemod/plugins/properpregame.smx" -O "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/properpregame.smx"
	echo -e "\nsm plugins unload properpregame" >> "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/soap_live.cfg"
	echo -e "\nsm plugins load properpregame" >> "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/soap_notlive.cfg"
fi

# Add cfg to exec in server.cfg before server starts
if [ ! -z "$CONFIG" ]; then
	sed -i '$a\\nexec "'"${CONFIG}"'"' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
fi

# Edit important cvars in server.cfg
sed -i -E 's/hostname "(.*)"/hostname "'"${HOSTNAME//\//\\/}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
sed -i -E 's/sv_password "(.*)"/sv_password "'"${SV_PW}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" 
sed -i -E 's/rcon_password "(.*)"/rcon_password "'"${RCON_PW}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" 
sed -i -E 's/tv_password "(.*)"/tv_password "'"${STV_PW}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" 
sed -i -E 's/tv_name "(.*)"/tv_name "'"${STV_NAME}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" 

# Add logstf api key
if [ ! -z "$LOGSTF_APIKEY" ]; then
	sed -i -E 's/logstf_apikey "(.*)"/logstf_apikey "'"${LOGSTF_APIKEY//\//\\/}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
fi

# Add demostf api key
if [ ! -z "$DEMOSTF_APIKEY" ]; then
	sed -i -E 's/sm_demostf_apikey "(.*)"/sm_demostf_apikey "'"${DEMOSTF_APIKEY//\//\\/}"'"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
fi

# Start the server
# Apparently srcds_run shits itself without this cd ¯\_(ツ)_/¯
cd "${STEAMAPPDIR}"
bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
				-steam_dir "${STEAMCMDDIR}" \
				-steamcmd_script "${HOMEDIR}/tf2_ds.txt" \
				-usercon \
				+maxplayers "${MAX_PLAYERS}" \
				+map "${START_MAP}" 
