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

#Load Java onto Phoenix, required to support GATK
module load Java/1.8.0_71 
results=$?
if [ $results -ne 0 ]
then
	echo  "Java/1.8.0_71 program loading failed"
	echo -e " \n "
	exit 3
fi

#Load GATK onto Phoenix, required for genotype likelihood by ANGSD
module load GATK/3.5-Java-1.8.0_71 
results=$?
if [ $results -ne 0 ]
then
	echo "GATK/3.5-Java-1.8.0_71  program loading failed"
	echo -e " \n "
	exit 4
fi

module load SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 

results=$?
if [ $results -ne 0 ]
then
	echo SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 program loading failed
	echo -e " \n "
	exit 5
fi

OUTDIR=~/Chicken_Output/ANGSD_Out/geno_galGal5
REFDIR=/data/biohub/Refs/Chicken/Galgal5.0
REFGENE=Gallus_gallus-5.0-short.fa

#Indexing the Reference Genome
samtools faidx ${REFDIR}/${REFGENE}

FILES=galGal5.list
echo "Found ${FILES}" |less ${FILES}

echo "Start genotype calling"
angsd -doMajorMinor 1 -dogeno 5 -ref ${REFDIR}/${REFGENE} -bam ${FILES} -doCounts 1 -GL 2 -doMaf 8 -doPost 1 -out ${OUTDIR} 

#-dogeno for genotype calling, -docounts for Count the number A,C,G,T. All sites, All samples
#-GL 2 for show genotype likelihood using GATK, allele frequency with 8 for AlleleCounts based method (known major minor)
#doMajorMinor to identify the major and minor alleles, dopost is compulsory for Genotype calling -1: estimate the posterior genotype probability based on the allele frequency as a prior


echo "Found ${OUTDIR}"
results=$?
if [ $results -ne 0 ]
then
	echo "Genotype calling failed"
	echo -e " \n "
	exit 6
fi
exit

