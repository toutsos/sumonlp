#!/bin/bash

if [ -z "$1" ]
then
      echo "$1 is empty"
      exit 1
else
      echo "running training.sh script with parameter $1"
      echo "expects to find data files in $1/data"
fi

if [ -z nmt ]
then
      echo "current directory does not contain required nmt dir"
      exit 1
fi

REPO=$1

DATA=$REPO/data

echo "training on data in $DATA"

LOGS=$REPO/logs

MODELS=$REPO/models

if [ -d "$MODELS/model/hparam*" ]; then
    rm -r $MODELS/model/hparam*
else
    echo "No hparam files to remove."
fi

mkdir -p $LOGS

if [ -d "$MODELS/model" ]
then
      mkdir -p $MODELS/model
fi

echo "output model in $MODELS/model"

echo "starting at date/time"
date

DATE=`date +"%y-%m-%d-%H-%M-%S"`

export CUDA_VISIBLE_DEVICES=0
python -m nmt.nmt \
  --encoder_type=bi \
  --attention=scaled_luong \
  --num_units=512 \
  --num_gpus=1 \
  --batch_size=32 \
  --src=nat --tgt=sum1 \
  --vocab_prefix=$DATA/vocab \
  --train_prefix=$DATA/train \
  --dev_prefix=$DATA/dev \
  --test_prefix=$DATA/test \
  --out_dir=$MODELS/model \
  --num_train_steps=4000 \
  --steps_per_stats=100 \
  --steps_per_external_eval=100 \
  --tgt_max_len=400 \
  --tgt_max_len_infer=400 \
  --num_layers=2 \
  --dropout=0.2 \
  --metrics=bleu > $LOGS/sumonlp-$DATE

#  --beam_width=10 \
#  --num_translations_per_input=10 > /home/mptp/nmt1/tg1/train.log

echo "metrics found in $LOGS/sumonlp-$DATE"
echo "model is in $MODELS/model"
