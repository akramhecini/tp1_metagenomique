#!/bin/bash	

cd fastq

#gunzip *.gz

for file in $(ls *_R1.fastq); do

   #echo $file #afficher le nom du file
   R1="$file"
   #echo $R1
   R2=$(echo $file|sed  's/R1/R2/g')
   echo $R2
   #fastqc $R1 $R2 
   
   #java -jar ~/tp_metagenomique_1/tp_1/soft/AlienTrimmer.jar -if $R1 -ir $R2 -q 20 -c ~/tp_metagenomique_1/tp_1/databases/contaminants.fasta
   
   R3=$R1".at.fq"
   R4=$R2".at.fq"
   R5="${R1:0:-9}"
   R6=$R5".fasta" 
   short="${R1:0:-9}"
   sig=";sample=$short;";

   #vsearch --fastq_mergepairs $R3 --reverse $R4 --fastqout $R6 --label_suffix $sig

   #cat *.fasta > amplican.fasta

   #sed "s/ //g" amplican.fasta > amplican.fasta

   #vsearch --derep_fulllength amplican.fasta --output full_length_amplican.fasta --minuniquesize 10

   #vsearch --derep_prefix amplican.fasta --output prefix_amplican.fasta --minuniquesize 10

   #vsearch --uchime_denovo prefix_amplican.fasta --nonchimeras non_chimer.fasta
   
   otu="out_"

   vsearch --cluster_size non_chimer.fasta --id 0.97 --centroids cluster.fasta --relabel $otu
   
   

done

cd .. 
