#!/bin/bash

# Find directories starting with 'run_PDF_' and loop through each
find . -type d -name 'run_PDF_140*' | while read -r dir; do
    # Count the number of files ending with '*NLO.top' in this directory
    count=$(find "$dir" -maxdepth 1 -type f -name '*xg2*rmngrid.top' -size +0 | wc -l)
    echo "$dir: $count"
done

