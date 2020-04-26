#!/bin/bash

#SBATCH --time=2:00:00
#SBATCH --partition=mstephens
#SBATCH --account=pi-mstephens
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=4G
#SBATCH --job-name=nb-tunnel
#SBATCH --output=nb-log-%J.out
#SBATCH --error=nb-log-%J.err

# activate the conda env 
conda init bash
conda activate drift

ip=$(/sbin/ip route get 8.8.8.8 | awk '{print $NF;exit}')
port=$((10000+ $RANDOM % 20000))

echo "http://"$ip":"$port"/"
jupyter notebook --no-browser --ip=$ip --port=$port --log-level='ERROR'
