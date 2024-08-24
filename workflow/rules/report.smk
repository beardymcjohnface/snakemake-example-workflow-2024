import os

rule flagstat:
    input:
        os.path.join(config["outdir"], "{sample}.bam")
    output:
        os.path.join(config["outdir"], "{sample}.flagstat.txt")
    log:
        os.path.join(config["logdir"], "flagstat.{sample}.log")
    shell:
        "samtools flagstat {input} > {output} 2> {log}"


rule multiqc:
    input:
        expand(os.path.join(config["qcdir"], "{sample}.fastp.{ext}"),sample=config["samples"],ext=["json", "html"]),
        expand(os.path.join(config["outdir"], "{sample}.flagstat.txt"),sample=config["samples"])
    output:
        os.path.join(config["outdir"], "multiqc_report.html"),
        directory(os.path.join(config["outdir"], "multiqc_report_data"))
    params:
        config = os.path.join("config", "multiqc_config.yaml"),
        outdir = config["outdir"],
        qcdir = config["qcdir"],
        prefix = os.path.join(config["outdir"], "multiqc_report")
    log:
        os.path.join(config["logdir"], "multiqc.log")
    shell:
        "multiqc -c {params.config} -n {params.prefix} {params.outdir} {params.qcdir}"
