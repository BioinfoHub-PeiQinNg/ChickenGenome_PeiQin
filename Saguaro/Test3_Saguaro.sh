#!/bin/bash
#SBATCH -p batch                                         # partition (this is the queue your job will be added to)
#SBATCH -N 1                                             # number of nodes
#SBATCH -n 16                                           
#SBATCH --time=24:00:00                                   # time allocation
#SBATCH --mem=80GB                     # memory
#SBATCH -o /home/a1674548/slurm/slurm_%j.out            
#SBATCH -e /home/a1674548/slurm/slurm_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=peiqin.ng@student.adelaide.edu.au

#loading Saguaro
module load SaguaroGW/20150315-foss-2016uofa
results=$? 
if [ $results -ne 0 ]
then
	echo "SaguaroGW/20150315-foss-2016uofa program loading failed"
	echo -e " \n "
	exit 1
fi

#Defining variable
Saguaro -f /fast/users/a1674548/Saguaro/filter_minMinor1_Melgal5_haplo_saguaro.feature  -o /fast/users/a1674548/Saguaro/filter_minMinor1_Melgal5_haplo_saguaro_outfile

OUT=fast/users/a1674548/Saguaro/filter_minMinor1_Melgal5_haplo_saguaro_outfile
echo "Found ${OUT}"
results=$?
if [ $results -ne 0 ]
then
	echo "Saguaro Output file not found"
	echo -e " \n "
	exit 2
fi

#using all default variable of '-cycle', '-iter' and '-t'
#-cycle<int> : iterations per cycle (def=2)
#-iter<int> : iterations with split (def=40)
#-t<double> : transition penalty (def=150)