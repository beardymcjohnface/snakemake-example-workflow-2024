# Example Snakemake workflow for the SAGC Workflow manager workshop 2024

The Snakemake workflow is based off the example bash script at the bottom.

## Environment

Install with conda

```shell
conda create -n snakemake snakemake fastp samtools minimap2 multiqc
```

## Bash script version

```shell
#!/usr/bin/bash
set -e  

# define variables
samples="A B C"
InDir="data/samples"
OutDir="output/aligned"
genome="data/genome.fa"
QCDir="output/QC"
LogDir="output/Logs"
threads=2

mkdir -p $OutDir
mkdir -p $QCDir
mkdir -p $LogDir

# iterate through samples
for sample in $samples
do
  # define input and output
  reads=${InDir}/${sample}.fastq
  samfile=${OutDir}/${sample}.sam
  bamfile=${OutDir}/${sample}.bam

  # run pre-mapping QC
  fastp -i ${reads} \
    --json ${QCDir}/${sample}.fastp.json \
    --html ${QCDir}/${sample}.fastp.html
  
  # map reads
  minimap2 -t ${threads} -a -x sr ${genome} ${reads} > ${samfile} 2> ${LogDir}/${sample}.minimap2.log

  # convert SAM to BAM
  samtools view -bh -o ${bamfile} ${samfile}

  # delete temporary data
  rm ${samfile}
  
  # post-mapping QC
  samtools flagstat ${bamfile} > ${bamfile}.flagstat.txt
done

# combine QC data into a single multiQC report
multiqc -c multiqc_config.yml -n ${QCDir}/multiqc_report ${QCDir} ${OutDir}
```