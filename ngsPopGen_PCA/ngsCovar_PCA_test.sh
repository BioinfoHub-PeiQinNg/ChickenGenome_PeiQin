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
 
#load the module ngsTools to use ngsCovar
module load ngsTools/ngsTools-GCC-5.3.0-binutils-2.25
results=$?
if [ $results -ne 0 ]
then
	echo  "ngsTools/ngsTools-GCC-5.3.0-binutils-2.25 program loading failed"
	echo -e " \n "
	exit 1
fi

WRKDIR=~/Chicken_Output/ANGSD_Out
INPUTGENO=ngsPopGen_input_test2.geno
INPUTMAFS=ngsPopGen_input_test2.mafs.gz
OUTDIR=~/Chicken_Output/ANGSD_Out/PCA_Out_Melgal5


echo "Identifying the number of sites in the input file"

#`.....` seem to give special permission to access compressed files with zcat function
less -S ${WRKDIR}/${INPUTMAFS}
N_SITES=`zcat ${WRKDIR}/${INPUTMAFS} | tail -n+2 | wc -l`
echo $N_SITES

#before this you will need to identify the N_Sites by the following command lines
#less -S Results/ALL.mafs.gz
#N_SITES=`zcat Results/ALL.mafs.gz | tail -n+2 | wc -l`
#echo $N_SITES
#run PCA by executing ngsCovar
ngsCovar -probfile ${WRKDIR}/${INPUTGENO} -outfile ${OUTDIR}.covar -nind 8 \
		 -nsites ${N_SITES} -call 0 -norm 0 

echo "Found ${OUTDIR}"
results=$?
if [ $results -ne 0 ]
then
	echo "ngsCovar PCA analysis unsuccessful"
	echo -e " \n "
	exit 2
fi
exit


# Input:
# -probfile: file with genotype posterior probabilities [required]
# -outfile: name of output file [required], currently it is a text file, tab separated with n*n cells
# -sfsfile: file with SFS posterior probabilities [required if you want to weight each site by its probability of being variable]
# -nind: nr of individuals [required]
# -nsites: nr of sites [required]
# -norm: if 0 no normalization, if 1 matrix is normalized by (p(1-p)) as in Patterson et al 2006, if 2 normalization is 2p(1-p) [0]
# -verbose: level of verbosity [0]
# -block_size: how many sites per block when reading the input file [0]
# -call: whether calling genotypes (1) or not (0) [0]
# -offset: starting position of subset analysis [1]
# -minmaf: filter out sites with estimated MAF less than minmaf or greater than 1-minmaf [0] 
#(this filtering will be ignored when using the weighting approach)
# -genoquality: text file with nsites lines; each line has a 0 and 1; if 0 the program will ignore this site [NULL]