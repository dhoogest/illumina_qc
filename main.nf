#!/usr/bin/env nextflow


fastq_pair_ch = Channel.fromFilePairs(params.input_folder + '/*_R{1,2}.fastq.gz', flat:true)


process fastqc {

    input:
    set pair_name, file(fastq1), file(fastq2) from fastq_pair_ch

    output:
    file "fastqc_${pair_name}_output" into fastqc_ch

    script:
    """
    mkdir fastqc_${pair_name}_output
    fastqc -o fastqc_${pair_name}_output $fastq1 $fastq2
    """
}


process multiqc {

   publishDir params.output_folder

   input:
   file('*') from fastqc_ch.collect()

   output:
   file "multiqc_report.html"

   script:
   """
   multiqc .
   """
}
