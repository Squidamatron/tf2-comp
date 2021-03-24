#!/bin/bash
cd "${STEAMCMDDIR}"
#./steamcmd.sh +runscript "${HOMEDIR}/tf2_ds.txt"
./steamcmd.sh +login anonymous \
		+force_install_dir "${STEAMAPPDIR}" \
		+app_update "${STEAMAPPID}" \
		+quit
