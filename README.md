## Team Fortress 2 Competitive Image

A Docker image for competitive TF2 using RGL configs

```
docker pull squidamatron/tf2-comp
```

## Included Addons and Plugins

- [Metamod:Source - 1.10](https://www.sourcemm.net/)
- [Sourcemod - 1.10](https://www.sourcemod.net/)
- [RGL Server Resources](https://github.com/RGLgg/server-resources-updater)
- [SOAP-DM](https://github.com/sapphonie/SOAP-TF2DM)
- [cURL](https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sourcemod-curl-extension/curl_1.3.0.0.zip)
	- [Updated curl.ext.so](https://forums.alliedmods.net/showpost.php?p=2432337&postcount=182)
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
START_MAP="cp_snakewater_final1"
MAX_PLAYERS="16"
CONFIG=""
LOGSTF_APIKEY=""
DEMOSTF_APIKEY=""
```
