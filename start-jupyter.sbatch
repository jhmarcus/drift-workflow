#!/bin/bash

#SBATCH --time=5:00:00
#SBATCH --partition=mstephens
#SBATCH --account=pi-mstephens
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=30G
#SBATCH --job-name=nb-tunnel
#SBATCH --output=nb-log-%J.out
#SBATCH --error=nb-log-%J.err

JUPYTER_PATH=/project2/jnovembre/jhmarcus/src/miniconda3/envs/alt_e/bin/jupyter

ip=$(/sbin/ip route get 8.8.8.8 | awk '{print $NF;exit}')
port=$((10000+ $RANDOM % 20000))

echo "http://"$ip":"$port"/"
$JUPYTER_PATH notebook --no-browser --ip=$ip --port=$port --log-level='ERROR'
