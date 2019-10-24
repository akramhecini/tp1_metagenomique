#!/bin/bash

dossier_reads_bruts=$1
dossier_sortie=$2

cd $1

mkdir dossier_sortie

for file in ./fastq/*_R1.fastq.gz; do
   gunzip $file
done

mkdir dossier_sortie/fastqc_reslts

for file in ./fastq/*_R1.fastq; do
   R2=$(echo $file|sed  's/R1/R2/g')
   fastqc $file $R2 -o $2/fastqc_reslts
done

mkdir dossier_sortie/trimmed

for file in ./fastq/*_R1.fastq; do
   R1=$(basename "$file")
   echo $R1S
   R2=$(echo $R1|sed  's/R1/R2/g')
   java -jar ./soft/AlienTrimmer.jar -if ./fastq/$R1 -ir ./fastq/$R2 -q 20 -c ./databases/contaminants.fasta -of $dossier_sortie/trimmed/$R1 -or $dossier_sortie/trimmed/$R2
done


mkdir dossier_sortie/fastq_mergepairs 

for file in ./fastq/*_R1.fastq; do

   R1=$(basename "$file")
   R2=$(echo $R1|sed  's/R1/R2/g')
   #R3=$R1".at.fq"
   #R4=$R2".at.fq"
   R5="${R1:0:-9}"
   R6=$R5".fasta"
   short="${R1:0:-9}"
   sig=";sample=$short;";

   vsearch --fastq_mergepairs $dossier_sortie/trimmed/$R1 --reverse $dossier_sortie/trimmed/$R2 --fastqout $dossier_sortie/fastq_mergepairs/$R6 --label_suffix $sig

done

#cat $dossier_sortie/fastq_mergepairs/*.fasta > amplican.fasta

#sed -i "s/ //g" ./amplican.fasta

#mv amplican.fasta $dossier_sortie






