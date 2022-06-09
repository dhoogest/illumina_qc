#!/usr/bin/env nextflow

def maybe_local(fname){
    // Address the special case of using test files in this project
    // when running in batchman, or more generally, run-from-git.
    if(file(fname).exists() || fname.startsWith('s3://')){
        return file(fname)
    }else{
        file("$workflow.projectDir/" + fname)
    }
}

fastq_pair_ch = Channel.fromFilePairs(params.run + '/*_R{1,2}*.fastq.gz', flat:true)
run = Channel.fromPath(params.run, type: 'dir')

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


process interop_summary {

    input:
        file(run)

    output:
        file "interop_summary.txt" into interop_summary
        file "interop_idx_summary.txt" into interop_idx_summary


    script:
        """
        interop_summary $run --csv=1 &> interop_summary.txt
        interop_index-summary $run --csv=1 > interop_idx_summary.txt
        """
}


process multiqc {

    input:
        file('*') from fastqc_ch.collect()
        file(interop_summary)
        file(interop_idx_summary)

    output:
        file "multiqc_report.html"

    publishDir params.run, overwrite:true, mode: 'copy'

    script:
        """
        multiqc .
        """
}
