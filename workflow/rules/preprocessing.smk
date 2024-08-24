import os

rule fastp:
    input:
        os.path.join(config["readdir"], "{sample}.fastq")
    output:
        json = os.path.join(config["qcdir"], "{sample}.fastp.json"),
        html = os.path.join(config["qcdir"], "{sample}.fastp.html")
    log:
        os.path.join(config["logdir"], "fastp.{sample}.log")
    shell:
        """
        fastp -i {input} \
            --json {output.json} \
            --html {output.html} \
            2> {log}
        """
