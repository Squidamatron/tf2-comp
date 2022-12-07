#!/bin/bash
cd "${STEAMCMDDIR}"
#./steamcmd.sh +runscript "${HOMEDIR}/tf2_ds.txt"
./steamcmd.sh +force_install_dir "${STEAMAPPDIR}" \
		+login anonymous \
		+app_update "${STEAMAPPID}" \
		+quit
