#!/bin/bash
mkdir plugins
cd plugins

# Metamod
LATESTMM=$(wget -qO- "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/mmsource-latest-linux")
wget -qO- "https://mms.alliedmods.net/mmsdrop/${METAMOD_VERSION}/${LATESTMM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

# Sourcemod
LATESTSM=$(wget -qO- "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/sourcemod-latest-linux")
wget -qO- "https://sm.alliedmods.net/smdrop/${SOURCEMOD_VERSION}/${LATESTSM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

# RGL Server Resources
LATESTRGL=$(curl -s https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].browser_download_url')
RGLDL=$(curl -s https://api.github.com/repos/RGLgg/server-resources-updater/releases/latest | jq -r '.assets[0].name')
wget -q "$LATESTRGL"
unzip "$RGLDL" -d "${STEAMAPPDIR}/${STEAMAPP}"
rm "$RGLDL"

# ETF2L CFG
wget -q "https://etf2l.org/configs/etf2l_configs.zip"
unzip "etf2l_configs.zip" -d "${STEAMAPPDIR}/${STEAMAPP}/cfg"
rm "etf2l_configs.zip"

# SOAP-DM
wget -q "https://github.com/sapphonie/SOAP-TF2DM/archive/master.zip" -O "soap-dm.zip"
unzip "soap-dm.zip"
cp -r SOAP-TF2DM-master/* "${STEAMAPPDIR}/${STEAMAPP}"
rm -r "SOAP-TF2DM-master"
rm "soap-dm.zip"

# curl
wget -q "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sourcemod-curl-extension/curl_1.3.0.0.zip"
unzip "curl_1.3.0.0.zip" -d "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/"
rm "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/extensions/curl.ext.so"
wget -q "https://raw.githubusercontent.com/spiretf/docker-comp-server/master/curl.ext.so" -O "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/extensions/curl.ext.so"
rm "curl_1.3.0.0.zip"

# Steamtools
wget -q "https://builds.limetech.io/files/steamtools-0.10.0-git179-54fdc51-linux.zip"
unzip "steamtools-0.10.0-git179-54fdc51-linux.zip" -d "${STEAMAPPDIR}/${STEAMAPP}"
rm "steamtools-0.10.0-git179-54fdc51-linux.zip"

# demos.tf
wget -q "https://github.com/demostf/plugin/raw/master/demostf.smx" -O "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/demostf.smx"

# F2 Plugins
wget -q "http://sourcemod.krus.dk/f2-sourcemod-plugins.zip"
unzip "f2-sourcemod-plugins.zip" -d f2
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

# server.cfg
mv "${HOMEDIR}/server.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"

# NA newbie mixes
echo -e "exec \"rgl_6s_5cp_scrim\"\nservercfgfile \"na_newbie\"\ntf_spec_xray \"1\"" > "na_newbie.cfg"
chmod 0644 "na_newbie.cfg"
mv "na_newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/na_newbie.cfg"

# At Rogue's Request :^)
echo -e "exec \"na_newbie\"" > "newbie.cfg"
chmod 0644 "newbie.cfg"
mv "newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/newbie.cfg"

# EU newbie mixes
echo -e "exec \"rgl_off\"\nservercfgfile \"eu_newbie\"\nexec \"etf2l_6v6_5cp\"" > "eu_newbie.cfg"
chmod 0644 "eu_newbie.cfg"
mv "eu_newbie.cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/eu_newbie.cfg"

# Just making sure :D
#chown -R "${USER}:${USER}" "${STEAMAPPDIR}/${STEAMAPP}"
cd "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/plugins/"
chmod -R 0644 *.smx

cd "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/extensions/"
chmod -R 0700 *

