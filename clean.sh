#!/bin/bash

cd "${STEAMAPPDIR}/${STEAMAPP}/maps"
shopt -s extglob

# Add full map file names to keep them in the directory
rm -v !("cp_process_final.bsp"|"cp_snakewater_final1.bsp"|"cp_gullywash_final1.bsp"|"cp_sunshine.bsp"|"cp_metalworks.bsp"|"cp_badlands.bsp"|"cp_granary.bsp"|"cp_reckoner.bsp")

# Everyone else does it ¯\_(ツ)_/¯
cd "${STEAMAPPDIR}/${STEAMAPP}/resource"
rm -v tf_*.txt

shopt -u extglob
