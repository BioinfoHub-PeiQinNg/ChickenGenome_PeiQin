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


#This script aims to use ANGSD to generate the input file for ngsPopGen PCA analysis
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

OUTDIR=~/Chicken_Output/ANGSD_Out/ngsPopGen_input_test2
REFDIR=~/Ref_Meleagris
REFGENE=mga_ref_Turkey_5.0-noUnplaced.fasta

#Indexing the Reference Genome
samtools faidx ${REFDIR}/${REFGENE}

FILES=Melgal5_list.txt
echo "Found ${FILES}" |less ${FILES}

echo "Start generating ngsPopGen input files"
angsd -b ${FILES} -ref ${REFDIR}/${REFGENE} -uniqueOnly 1 -remove_bads 1 -out ${OUTDIR} -GL 2 -doMajorMinor 1 -doMaf 1 -doGeno 32 -doPost 1 -minMaf 0.05 

#-dogeno 32 to generate gennotype posterior likelihod and give binary files output, -docounts for Count the number A,C,G,T. All sites, All samples
#-GL 2 for show genotype likelihood using GATK, allele frequency with 8 for AlleleCounts based method (known major minor)
#doMajorMinor to identify the major and minor alleles, dopost is compulsory for Genotype calling -1: estimate the posterior genotype probability based on the allele frequency as a prior
#doMafs function is required for the estimation of number of sites which will be used for ngsCovar_PCA analysis later
#-remove_bads [int]=1 Same as the samtools flags -x which removes read with a flag above 255 (not primary, failure and duplicate reads). 0 no , 1 remove (default).
#-minMafs 0.05: filter out sites with minimum allele frequency of 0.05
#-uniqueOnly 1:Remove reads that have multiple best hits


echo "Found ${OUTDIR}"
results=$?
if [ $results -ne 0 ]
then
	echo "ngsPopGen input files generation failed"
	echo -e " \n "
	exit 6
fi
exit

#example:
# ANGSD/angsd -P 4 -b ${FILES} -ref ${REFDIR}/${REFGENE} -out ${OUTDIR} -r 11 \
#         -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
#         -minMapQ 20 -minQ 20 -minInd 30 -setMinDepth 60 -setMaxDepth 400 -doCounts 1 \
#         -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
#         -SNP_pval 1e-3\
#         -doGeno 32 -doPost 1 &> /dev/null

