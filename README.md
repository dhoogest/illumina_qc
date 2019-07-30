## Simple QC workflow using Nextflow + AWS Batch

**Pipeline:**
1.  Run fastqc for pairs of fastq.gz files with paired-end reads
2.  Run multiqc on all results of step 1

**Params:** 

`input_folder` -- local directory or s3 bucket containing fastq.gz files with paired-end reads

`output_folder` -- local directory, where multiqc_report.html will be created (or copied to from s3 bucket)

### Running locally
Make sure that fastqc and multiqc installed and run
~~~~
nextflow main.nf -profile standard
~~~~


### Running with AWS Batch
Get AWS credentials for nextflow-user, set environmental variables
~~~~
export AWS_ACCESS_KEY_ID=<nextflow-user access key id>
export AWS_SECRET_ACCESS_KEY=<nextflow-user secret access key>
export AWS_DEFAULT_REGION='us-west-2'
~~~~
and run
~~~~
nextflow main.nf -profile batch
~~~~
