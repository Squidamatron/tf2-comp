#!/bin/bash

# Update {Meta,Source}Mod
if [ "$UPDATE_XM" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating MetaMod and SourceMod..."

	# Metamod
	LATEST_MM=$(curl -sS "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/mmsource-latest-linux")
	curl -sS "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/${LATEST_MM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

	# Sourcemod
	LATEST_SM=$(curl -sS "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/sourcemod-latest-linux")
	curl -sS "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/${LATEST_SM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Update CFGS
if [ "$UPDATE_CFGS" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating RGL and ETF2L cfgs..."

	# RGL Server Resources
	LATEST_RGL=$(curl -sS https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].browser_download_url')
	RGL_DL=$(curl -sS https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].name')
	curl -sSL "$LATEST_RGL" -o "$RGL_DL"
	unzip -f "$RGL_DL" -d "${STEAMAPPDIR}/${STEAMAPP}"
	rm "$RGL_DL"

	# ETF2L CFG
	LATEST_ETF2L=$(curl -sS https://api.github.com/repos/ETF2L/gameserver-configs/releases/latest | jq -r '.assets[0].browser_download_url')
	ETF2L_DL=$(curl -sS https://api.github.com/repos/ETF2L/gameserver-configs/releases/latest | jq -r '.assets[0].name')
	curl -sSL "$LATEST_ETF2L" -o "$ETF2L_DL"
	unzip -f "$ETF2L_DL" -d "${STEAMAPPDIR}/${STEAMAPP}/cfg"
	rm "$ETF2L_DL"
fi

# Update Plugins
if [ "$UPDATE_PLUGINS" -gt 0 ]; then
	cd "$HOME/plugins"

	echo "Updating plugins..."

	# SOAP-DM
	LATEST_SOAP=$(curl -sS "https://api.github.com/repos/sapphonie/SOAP-TF2DM/releases/latest" | jq -r '.assets[0].browser_download_url')
	SOAP_DL=$(curl -sS "https://api.github.com/repos/sapphonie/SOAP-TF2DM/releases/latest" | jq -r '.assets[0].name')
	curl -sSL "$LATEST_SOAP" -o "$SOAP_DL"
	unzip -f "$SOAP_DL" -d "${STEAMAPPDIR}/${STEAMAPP}"
	rm "$SOAP_DL"

	# demos.tf
	curl -sSL "https://github.com/demostf/plugin/raw/master/demostf.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/demostf.smx"

	# F2 Plugins
	curl -sS "http://sourcemod.krus.dk/f2-sourcemod-plugins.zip" -o "f2-sourcemod-plugins.zip"
	unzip "f2-sourcemod-plugins.zip" -d f2
	chmod 0664 f2/*
	cp f2/{afk,logstf,medicstats,recordstv,restorescore,supstats2}.smx "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/."
	rm -r "f2"
	rm "f2-sourcemod-plugins.zip"

	# Map Downloader
	curl -sSL "https://github.com/nutcity/mapdownloader/raw/master/plugin/mapdownloader.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/mapdownloader.smx"

	# proper-pregame
	curl -sSL "https://github.com/nutcity/ProperPregame/raw/master/addons/sourcemod/plugins/properpregame.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/properpregame.smx"
fi

# Sets Region
if [ ! -z "$REGION" ]; then
	if [ "$REGION" == "NA" ]; then
		echo "Setting REGION to NA..."
		# It's the Default, nothing changes! Unless some other plugins come in to play..."
	elif [ "$REGION" == "EU" ]; then
		echo "Setting REGION to EU..."
		# Delete RGL plugins
		if [ -a "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/rglqol.smx" ]; then
			rm "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/rglqol.smx"
		fi

		if [ -a "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/rglupdater.smx" ]; then
			rm "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/rglupdater.smx"
		fi
	else
		echo "Unknown Region :O"
	fi
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
