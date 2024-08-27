#!/bin/bash
MODEL=$1

if [ ! -d "$1" ]
then
      echo "\$1 is empty"
      exit 1
else
      echo "running test.sh script with parameter $1"
fi

echo "starting at date/time"
date

echo "trying model at $MODEL"
echo "type one or more sentences, then CTRL-D to start the test"
cat > input_infer.txt

python -m nmt.nmt \
    --out_dir=$MODEL \
    --inference_input_file=input_infer.txt \
    --inference_output_file=output_infer.txt

echo "showing output from file output_infer.txt"

cat output_infer.txt # To view the inference as output

