#!/bin/bash
#SBATCH -p batch                                         # partition (this is the queue your job will be added to)
#SBATCH -N 1                                             # number of nodes
#SBATCH -n 16                                           
#SBATCH --time=24:00:00                                   # time allocation
#SBATCH --mem=32GB                     # memory
#SBATCH -o /home/a1674548/slurm/slurm_%j.out            
#SBATCH -e /home/a1674548/slurm/slurm_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=peiqin.ng@student.adelaide.edu.au

#this script is for Abbababa 
module load ANGSD/0.915-GCC-5.3.0-binutils-2.25
results=$?
if [ $results -ne 0 ]
then
	echo "ANGSD/0.915-GCC-5.3.0-binutils-2.25 program loading failed"
	echo -e " \n "
	exit 1
fi

#Load zlib onto Phoenix
module load zlib/1.2.8-GCC-5.3.0-binutils-2.25
results=$?
if [ $results -ne 0 ]
then
	echo "zlib/1.2.8-GCC-5.3.0-binutils-2.25 program loading failed"
	echo -e " \n "
	exit 2
fi


#defining directories
OUTDIR=~/Chicken_Output/ANGSD_Out/MelGal5_GV_Out_abba

FILES=MelGal5_GV_out_list.txt
echo "Found ${FILES}" |less ${FILES}
#do Abbababa
#angsd -out out -doAbbababa 1 -bam smallBam.filelist -doCounts 1 -anc chimpHG19.fa
angsd -doAbbababa 1 -useLast 1 -out ${OUTDIR} -doCounts 1 -b ${FILES} 
#doAbbababa: Do D-stat test; useLast 1: use the last individual in the list as the outgroup; do counts:use -doCounts 1 in order to count the bases at each sites after filters


echo "Found ${OUTDIR}"
results=$?
if [ $results -ne 0 ]
then
	echo "Abbababa analysis failed"
	echo -e " \n "
	exit 3
fi
exit

