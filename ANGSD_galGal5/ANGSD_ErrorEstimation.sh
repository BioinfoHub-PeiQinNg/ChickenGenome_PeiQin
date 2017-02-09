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
#Use ANGSD to do SNP and haploid calling
#Genotype likelihoods (later)
#Load ANGSD onto Phoenix
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
 #Load SAMtools into Phoenix
module load SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 
results=$?
if [ $results -ne 0 ]
then
	echo SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 program loading failed
	echo -e " \n "
	exit 3
fi

OUTDIR=~/Chicken_Output/ANGSD_Out/galGal5
REFDIR=/data/biohub/Refs/Chicken/Galgal5.0
REFGENE=Gallus_gallus-5.0-short.fa

#Indexing the Reference Genome
samtools faidx ${REFDIR}/${REFGENE}

FILES=galGal5.list
echo "Found ${FILES}" |less ${FILES}

echo "Start Error Estimation"

angsd -bam ${FILES} -doCounts 1 -doMajorMinor 2 -out ${OUTDIR}  -doError 1 

OUT=~/Chicken_Output/ANGSD_Out/galGal5.error.chunkunordered
echo "Found ${OUT}"
results=$?
if [ $results -ne 0 ]
then
	echo "Error Estimation failed"
	echo -e " \n "
	exit 4
fi
exit

