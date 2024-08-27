#!/bin/bash

# this is where the github repo's root is
REPO=/home/peaseada/test1/sumonlp

DATA=$REPO/data/data1

LOGS=$REPO/logs

MODELS=$REPO/models

python -m nmt.nmt \
  --encoder_type=bi \
  --attention=scaled_luong \
  --num_units=512 \
  --num_gpus=1 \
  --batch_size=768 \
  --src=nat --tgt=sum1 \
  --vocab_prefix=$DATA/vocab \
  --train_prefix=$DATA/train \
  --dev_prefix=$DATA/dev \
  --test_prefix=$DATA/test \
  --out_dir=$MODELS/model92 \
  --num_train_steps=18000 \
  --steps_per_stats=2000 \
  --steps_per_external_eval=2000 \
  --num_layers=2 \
  --dropout=0.2 \
  --metrics=bleu > $LOGS/train.log12kb92
#  --beam_width=10 \
#  --num_translations_per_input=10 > /home/mptp/nmt1/tg1/train.log

# cat /home/qwang/nmt/miz2pref/data/test.miz /home/qwang/nmt/miz2pref/data/dev.miz > /home/qwang/nmt/miz2pref/data/pump.miz
# cat /home/qwang/nmt/miz2pref/data/test.pref /home/qwang/nmt/miz2pref/data/dev.pref > /home/qwang/nmt/miz2pref/data/pump-compare.pref

# python -m nmt.nmt \
#   --beam_width=10 \
#   --num_translations_per_input=10 \
#   --out_dir=/home/qwang/nmt/miz2pref/model \
#   --inference_input_file=/home/qwang/nmt/miz2pref/data/pump.miz \
#   --inference_output_file=/home/qwang/nmt/miz2pref/data/pump.pref > /home/qwang/nmt/miz2pref/infer.log
