## Team Fortress 2 Competitive Image

A Docker image for competitive TF2 using RGL and ETF2L configs

```
docker pull squidamatron/tf2-comp
```

## Included Addons and Plugins

- [Metamod:Source - 1.11](https://www.sourcemm.net/)
- [Sourcemod - 1.11](https://www.sourcemod.net/)
- [RGL Server Resources](https://github.com/RGLgg/server-resources-updater)
- [SOAP-DM](https://github.com/sapphonie/SOAP-TF2DM)
- [cURL](https://github.com/sapphonie/SM-neocurl-ext)
- [Steamtools](https://builds.limetech.io/?p=steamtools)
- [demostf](https://github.com/demostf/plugin)
- [F2 Plugins](https://www.teamfortress.tv/13598/?page=1#post-1)
	- AFK
	- LogsTF
	- MedicStats
	- RecordSTV
	- RestoreScore
	- SupStats2
- [Map Downloader](https://github.com/nutcity/mapdownloader)
- [ProperPregame](https://github.com/nutcity/ProperPregame)

## Maps

This image only includes the stock maps used in 6s. Any other map is handled by the Map Downloader and the associated FastDL.

## Environment Variables

```dockerfile
HOSTNAME="TF2 Server"
STV_NAME="SourceTV"
SV_PW="changeme"
STV_PW="changeme"
RCON_PW="changeme"
START_MAP="cp_process_final"
MAX_PLAYERS="16"
CONFIG=""
METAMOD_VERSION="1.11"
SOURCEMOD_VERSION="1.11"
UPDATE_XM="0"
UPDATE_CFGS="0"
UPDATE_PLUGINS="0"
LOGSTF_APIKEY=""
DEMOSTF_APIKEY=""
```
`UPDATE_XM` Updates MetaMod and SourceMod to a newer version.  
`UPDATE_CFGS` Downloads the current versions of ETF2L CFGs and RGL Plugins.  
`UPDATE_PLUGINS` Downloads the current versions of SOAP-DM, demostf, F2, Map Downloader, ProperPregame plugins.

All `UPDATE_` envs will accept `1` as a value to run updates and will attempt to run an update on every container start.
