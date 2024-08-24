import os

rule minimap:
    input:
        reads = os.path.join(config["readdir"], "{sample}.fastq"),
        genome = config["genome"]
    output:
        temp(os.path.join(config["outdir"], "{sample}.sam"))
    threads:
        2
    log:
        os.path.join(config["logdir"], "minimap.{sample}.log")
    shell:
        """
        minimap2 \
            -t {threads} \
            -ax sr \
            {input.genome} \
            {input.reads} \
            > {output} \
            2> {log}
        """

rule sort_alignment:
    input:
        os.path.join(config["outdir"], "{sample}.sam")
    output:
        os.path.join(config["outdir"], "{sample}.bam")
    log:
        os.path.join(config["logdir"], "samtools.{sample}.log")
    shell:
        """
        samtools sort -o {output} {input} 2> {log}
        """
