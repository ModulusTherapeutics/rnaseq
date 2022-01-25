#!/bin/bash
#
# test_nextflow_local.sh
#
# Test pipeline locally
#
# Copyright (C) 2022 Matthew Stone <matthew.stone@modulustherapeutics.com>

mkdir -p logs

nextflow run main.nf \
    -profile test,docker \
    -with-report logs/local_report.html \
    -with-trace logs/local_trace.txt \
    -with-timeline logs/local_timeline.html \
    -with-dag logs/local_flowchart.png
