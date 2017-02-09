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

module load SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 

results=$?
if [ $results -ne 0 ]
then
	echo SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 program loading failed
	echo -e " \n "
	exit 3
fi

OUTDIR=~/Chicken_Output/ANGSD_Out/filter_minMinor1_Melgal5
REFDIR=~/Ref_Meleagris
REFGENE=mga_ref_Turkey_5.0-noUnplaced.fasta

#Indexing the Reference Genome
samtools faidx ${REFDIR}/${REFGENE}

FILES=Melgal5_list.txt
echo "Found ${FILES}" |less ${FILES}

echo "Start haploid calling"

angsd -doHaploCall 2 -ref ${REFDIR}/${REFGENE} -bam ${FILES} -doCounts 1 -minMinor 1 -maxMis 0 -out ${OUTDIR} 

#-dohaplocall for haploid calling, -docounts for Count the number A,C,G,T. All sites, All samples
#minMinor 2: Minimum observed minor alleles; only prints sites with more than 2 minor sampled alleles (across individuals).
#maxMis 0: maximum allowed missing alleles (accross individuals). -maxMis 0 means only sites without missing alleles are printed

OUT=~/Chicken_Output/ANGSD_Out/filter_minMinor1_Melgal5.haplo.gz
echo "Found ${OUT}"
results=$?
if [ $results -ne 0 ]
then
	echo "Haploid calling filter failed"
	echo -e " \n "
	exit 4
fi
exit

