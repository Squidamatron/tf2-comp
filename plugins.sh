#!/bin/bash
mkdir plugins
cd plugins

# Metamod
LATEST_MM=$(curl -sS "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/mmsource-latest-linux")
curl -sS "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/${LATEST_MM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

# Sourcemod
LATEST_SM=$(curl -sS "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/sourcemod-latest-linux")
curl -sS "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/${LATEST_SM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

# RGL Server Resources
read -r LATEST_RGL RGL_DL < <(echo $(curl -sS "https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest" | jq -r '.assets[0].browser_download_url, .assets[0].name'))
curl -sSL "$LATEST_RGL" -o "$RGL_DL"
unzip "$RGL_DL" -d "${STEAMAPPDIR}/${STEAMAPP}"
rm "$RGL_DL"

# ETF2L CFG
read -r LATEST_ETF2L ETF2L_DL < <(echo $(curl -sS "https://api.github.com/repos/ETF2L/gameserver-configs/releases/latest" | jq -r '.assets[0].browser_download_url, .assets[0].name'))
curl -sSL "$LATEST_ETF2L" -o "$ETF2L_DL"
unzip "$ETF2L_DL" -d "${STEAMAPPDIR}/${STEAMAPP}/cfg"
rm "$ETF2L_DL"

# SOAP-DM
read -r LATEST_SOAP SOAP_DL < <(echo $(curl -sS "https://api.github.com/repos/sapphonie/SOAP-TF2DM/releases/latest" | jq -r '.assets[0].browser_download_url, .assets[0].name'))
curl -sSL "$LATEST_SOAP" -o "$SOAP_DL"
unzip "$SOAP_DL" -d "${STEAMAPPDIR}/${STEAMAPP}"
rm "$SOAP_DL"

# neocurl
read -r LATEST_NEOCURL NEOCURL_DL < <(echo $(curl -sS "https://api.github.com/repos/sapphonie/SM-neocurl-ext/releases/latest" | jq -r '.assets[0].browser_download_url, .assets[0].name'))
curl -sSL "$LATEST_NEOCURL" -o "$NEOCURL_DL"
unzip "$NEOCURL_DL" -d "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/"
rm "$NEOCURL_DL"

# demos.tf
curl -sSL "https://github.com/demostf/plugin/raw/master/demostf.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/demostf.smx"

# F2 Plugins
read -r LATEST_F2 F2_DL < <(echo $(curl -sS "https://api.github.com/repos/F2/F2s-sourcemod-plugins/releases/latest" | jq -r '.assets[0].browser_download_url, .assets[0].name'))
curl -sSL "$LATEST_F2" -o "$F2_DL"
unzip "$F2_DL" -d "f2"
chmod 0664 f2/*
cp f2/{afk,logstf,medicstats,recordstv,supstats2}.smx "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/."
rm -r "f2"
rm "$F2_DL"

# Map Downloader
curl -sSL "https://github.com/spiretf/mapdownloader/raw/master/plugin/mapdownloader.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/mapdownloader.smx"

# proper-pregame
curl -sSL "https://github.com/AJagger/ProperPregame/raw/master/addons/sourcemod/plugins/properpregame.smx" -o "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/properpregame.smx"
echo -e "\nsm plugins unload properpregame" >> "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/soap_live.cfg"
echo -e "\nsm plugins load properpregame" >> "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/soap_notlive.cfg"

# server.cfg
mv "${HOMEDIR}/server.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"

# gamejson plugin
mv "${HOMEDIR}/gamejson.smx" "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/gamejson.smx"

# speclock plugin
mv "${HOMEDIR}/splock.smx" "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/splock.smx"

# NA newbie mixes
echo -e "exec \"rgl_6s_5cp_scrim\"\nservercfgfile \"na_newbie\"\ntf_spec_xray \"1\"\nsm_democheck_enabled \"0\"" > "na_newbie.cfg"
chmod 0644 "na_newbie.cfg"
mv "na_newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/na_newbie.cfg"

# At Rogue's Request :^)
echo -e "exec \"na_newbie\"" > "newbie.cfg"
chmod 0644 "newbie.cfg"
mv "newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/newbie.cfg"

# EU newbie mixes
echo -e "exec \"etf2l_6v6_5cp\"\nservercfgfile \"eu_newbie\"" > "eu_newbie.cfg"
chmod 0644 "eu_newbie.cfg"
mv "eu_newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/eu_newbie.cfg"

# Just making sure :D
#chown -R "${USER}:${USER}" "${STEAMAPPDIR}/${STEAMAPP}"
cd "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/"
rm nextmap.smx
chmod -R 0644 *.smx

cd "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/extensions/"
chmod -R 0700 *

# Stop the steamclient.so missing error
mkdir -p "${HOMEDIR}/.steam/sdk32"
cd "${HOMEDIR}/.steam/sdk32"
ln -s "${HOMEDIR}/steamcmd/linux32/steamclient.so" steamclient.so
