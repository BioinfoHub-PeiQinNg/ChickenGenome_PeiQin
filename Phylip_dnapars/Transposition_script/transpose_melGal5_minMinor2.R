#This script is for reformmating of ANGSD output for phylogenetic analysis
#Set the working directory
setwd("/Users/SabrinaNg/Desktop/Transposition_ChickenGenome")
#load the library magrittr and ape
library(magrittr)
library(ape) #a good R package to read fasta file
#read the reference genome and the ANGSD output 
seq <- read.dna("mga_ref_Turkey_5.0-noUnplaced.fasta",format = "fasta")
snp <- read.table("filter_minMinor2_Melgal5_haplo.tsv",header=TRUE)
#define the outfile for the output
outfile <- "filter_minMinor2_Melgal5_haplo_transpose.txt"
#When the outgroup reference genome is included, number of individuals changes from 8 to 9
cat("9 ",nrow(snp),"\n",file = outfile,append = FALSE,sep="")
#concatenate the outgroup reference sites onto the outfile
cat("outgroup   ",file=outfile,append = TRUE)
#find labels in vector seq and put it into a new vector chromosome
chromosomes <- labels(seq)
#initiate a loop which filters the position of sites in the reference genome that corresponds to the sites where snp(s) are detected for the ANGSD output
for (i in 1:length(chromosomes)){
  pos <- dplyr::filter(snp,chr==chromosomes[i])$pos
  seqChr <- as.character(seq[i])[[1]][pos] 
  cat(paste0(seqChr,collapse = ""),file = outfile,append = TRUE)
}
cat("\n",file = outfile,append = TRUE)
#Renaming the column names ie. ind* to its actual sample name for identification in phylogenetic tree analysis by first creating a new variable
realName <- c("A15091_GV" , "A15100_GL" , "A16282_GS" , "Fiji_11700", "Ifugao_132" , "Marquesas_9034" , "Palawan_237" , "Vanuatu_11740")

for (i in 4:11){
  ind<-paste0(snp[,i] %>% as.character(),collapse = "")  
  name <- realName[i-3]
  nb <- nchar(name)
  if (nb<=10){
    cat(name,rep(" ",10-nb)," ",ind,"\n",file=outfile,append = TRUE,sep="")  #definition of function only required for Phylip as it only accepts input name with the length of 10
  }
  else{
    cat(substr(name,1,10)," ",ind,"\n",file=outfile,append = TRUE,sep="")  
  }
}

#the script is written by Dr. Hien To; modified to use by Sabrina Ng
