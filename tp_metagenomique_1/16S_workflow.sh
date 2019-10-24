#!/bin/bash

dossier_reads_bruts=$1
dossier_sortie=$2

#cd $1

mkdir $dossier_sortie
mkdir $dossier_sortie/fastqc_reslts
mkdir $dossier_sortie/amplican
mkdir $dossier_sortie/prefix_amplican
mkdir $dossier_sortie/full_length_amplican
mkdir $dossier_sortie/non_chimer
mkdir $dossier_sortie/cluster
mkdir $dossier_sortie/fastq_mergepairs 
mkdir $dossier_sortie/trimmed





for file in ./fastq/*.fastq.gz; do
   gunzip $file
done



for file in ./fastq/*_R1.fastq; do
   R2=$(echo $file|sed  's/R1/R2/g')
   fastqc $file $R2 -o $2/fastqc_reslts
done

for file in ./fastq/*_R1.fastq; do
   R1=$(basename "$file")
   echo $R1S
   R2=$(echo $R1|sed  's/R1/R2/g')
   java -jar ./soft/AlienTrimmer.jar -if ./fastq/$R1 -ir ./fastq/$R2 -q 20 -c ./databases/contaminants.fasta -of $dossier_sortie/trimmed/$R1 -or $dossier_sortie/trimmed/$R2
done


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

cat $dossier_sortie/fastq_mergepairs/*.fasta > amplican.fasta

sed -i "s/ //g" ./amplican.fasta


vsearch --derep_fulllength amplican.fasta --output full_length_amplican.fasta --minuniquesize 10


vsearch --derep_prefix amplican.fasta --output prefix_amplican.fasta --minuniquesize 10
''

vsearch --uchime_denovo prefix_amplican.fasta --nonchimeras non_chimer.fasta


otu=">OTU_"


vsearch --cluster_size non_chimer.fasta --id 0.97 --centroids cluster.fasta --relabel $otu


vsearch --usearch_global cluster.fasta --db ./databases/mock_16S_18S.fasta --userout annotation --id 0.90 --top_hits_only --userfields "query+target"


sed '1iOTU\tAnnotation' -i annotation


#nettoyage : 


mv annotation $dossier_sortie/annotation

for i in *.fasta;do
   j=${i:0:-6}
   mv $i $dossier_sortie/$j
done


