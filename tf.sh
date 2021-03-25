#!/bin/bash

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
