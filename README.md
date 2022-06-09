## Simple Illumina QC workflow:  Nextflow + AWS Batch

**Pipeline:**
1.  Run fastqc for pairs of fastq.gz files with paired-end reads
2.  Run illumina summary commands on InterOp output (see [here](http://illumina.github.io/interop/index.html) for more info)
3.  Run multiqc on all results of step 1

**Params:**

- `run`:local directory or s3 bucket containing fastq.gz files with paired-end reads along with
		Illumina InterOp, RunInfo.xml, runParameters.xml files.

### Running locally
Make sure that fastqc and multiqc installed and run
~~~~
nextflow main.nf -profile standard --run test
~~~~


### Running with AWS Batch
Get AWS credentials for AWS via `saml2aws login` and run:
~~~~
nextflow main.nf -profile uw_batch --run {path to run}
~~~~
