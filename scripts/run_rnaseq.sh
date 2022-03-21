#!/bin/bash
#
# run_rnaseq.sh
#
# Deploy rnaseq pipeline on AWS Batch
#
# Authors:
#   Matt Stone <matthew.stone@modulustherapeutics.com>
#
# Copyright (C) 2022 Modulus Therapeutics

usage() {
  cat <<EOF
usage: %FFILE% [-h] samplesheet outdir

Deploy rnaseq pipeline on AWS Batch.

Required arguments:
  samplesheet  Input samplesheet (see nf-core/rnaseq docs).
  outdir       Output directory (relative to S3_PATH).

Optional arguments:
  -s S3_PATH   S3 bucket to store outputs.
	         [default: s3://modulus-processed/rnaseq]  
  -h           Show this help message and exit.
EOF
}

# Default parameters
S3_PATH="s3://modulus-processed/rnaseq"

while getopts ":h" opt; do
  case ${opt} in
    h)
      usage
      exit 0
      ;;
    s)
      S3_PATH=${OPTARG}
      ;;
    *)
      echo -e "error: Invalid option \"-${OPTARG}\"\n" 1>&2
      usage
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

SAMPLESHEET=$1
OUTDIR=$2

S3_OUTDIR="${S3_PATH}/${OUTDIR}"
S3_WORKDIR="${S3_OUTDIR}/work"
S3_LOGDIR="${S3_OUTDIR}/logs"

# TODO validate samplesheet

# Run pipeline
nextflow run main.nf \
    -c nextflow.config \
    --input ${SAMPLESHEET} \
    --genome GRCh38 \
    -profile docker,awsbatch \
    -bucket-dir ${S3_WORKDIR} \
    -with-report ${S3_LOGDIR}/awsbatch_report.html \
    -with-trace ${S3_LOGDIR}/awsbatch_trace.txt \
    -with-timeline ${S3_LOGDIR}/awsbatch_timeline.html \
    -with-dag ${S3_LOGDIR}/awsbatch_flowchart.png \
    --outdir ${S3_OUTDIR} \
    -resume

# Clean up work files
aws s3 rm --recursive ${S3_WORKDIR}
