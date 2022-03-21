#!/bin/bash
#
# test_nextflow_awsbatch.sh
#
# Test pipeline on AWS Batch
#
# Copyright (C) 2022 Matthew Stone <matthew.stone@modulustherapeutics.com>
# Distributed under terms of the MIT license.

mkdir -p logs

nextflow run main.nf \
    -c nextflow.config \
    -profile test,docker,awsbatch \
    -bucket-dir s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/work/ \
    -with-report s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/logs/awsbatch_report.html \
    -with-trace s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/logs/awsbatch_trace.txt \
    -with-timeline s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/logs/awsbatch_timeline.html \
    -with-dag s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/logs/awsbatch_flowchart.png \
    --outdir s3://modulus-users/mstone/nextflow-rnaseq-batch-demo/
