#!/bin/bash
set -euo pipefail
mkdir test
wget -P ~/test https://nexintek.com/Datafiles/Dandelion_Test_SE.fastq.gz
fastqc -o ~/test ~/test/Dandelion_Test_SE.fastq.gz
java -jar ~/Trimmomatic-0.40/trimmomatic-0.40.jar SE ~/test/Dandelion_Test_SE.fastq.gz ~/test/Dandelion_Test_SE.TRIMED.fastq.gz TRAILING:15
fastqc -o ~/test ~/test/Dandelion_Test_SE.TRIMED.fastq.gz
wget -P ~/test https://genome-idx.s3.amazonaws.com/hisat/grch38_tran.tar.gz
tar -xvf ~/test/grch38_tran.tar.gz -C ~/test
hisat2 -q -p 5 --rna-strandness R -x ~/test/grch38_tran/genome_tran -U ~/test/Dandelion_Test_SE.TRIMED.fastq.gz -S ~/test/Dandelion_Test_SE.sam
samtools view -Sb ~/test/Dandelion_Test_SE.sam > ~/test/Dandelion_Test_SE.bam
samtools sort ~/test/Dandelion_Test_SE.bam -o ~/test/Dandelion_Test_SE.SORTED.bam
samtools index ~/test/Dandelion_Test_SE.SORTED.bam
echo "RNA-Seq pipeline completed successfully."