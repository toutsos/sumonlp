#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
      echo "$1 is empty and/or $2 is empty"
      echo "usage:  > ./preprocess.sh Dir Filename "
      exit 1
else
      echo "Running preprocessing script with parameters $1 and $2."
      echo "This script expects to find $1/$2-log.txt and $1/$2-eng.txt"
      echo "as files of logical expressions and their English"
      echo "equivalents, respectively."
fi

echo "starting at date/time"
date

DIR=$1  # take a parameter from the command line
NAME=$2  # take a parameter from the command line

# pushd .
# cd $DIR

# if [ -z "data" ]
# then
#       mkdir data
# fi

cd data
      
NAMELOG=$NAME-log.txt
NAMEENG=$NAME-eng.txt

cp $1/$NAMELOG .
cp $1/$NAMEENG .

perl -pe 's/,/ , /g; s/ +/ /g;' $NAMEENG > $NAMEENG-0
   # need to split 's and n't off from words into separate tokens

perl -pe 's/([()?])/ $1 /g; s/ +/ /g;' $NAMELOG > $NAMELOG-0

paste -d\# $NAMELOG-0 $NAMEENG-0 > out.merged  # horizontal merge of the two files

echo "finished horizontal merge"

shuf < out.merged > out.mergedR  # shuffles the lines in a file into random order

echo "finished shuffle"

NUM_LINES=$(wc -l < out.mergedR)

TRAIN_L=$((NUM_LINES * 96 / 100))
TRAIN_L=$((NUM_LINES * 96 / 100))

split -l $TRAIN_L out.mergedR       

mv xaa train.mergedR   # xaa is the name of the first file generated by split

mv xab bigtest.mergedR # xab is the name of the second file generated by split

BIGTEST_LINES=$(wc -l < bigtest.mergedR)
TEST_L=$((BIGTEST_LINES / 2))

head -n $TEST_L bigtest.mergedR > dev.mergedR
tail -n $TEST_L bigtest.mergedR > test.mergedR

for i in bigtest dev test train; do cut -f1 -d\# $i.mergedR > $i.sum1; done  # make sumo test and train files by extracting the first field (before the #)

for i in bigtest dev test train; do cut -f2- -d\# $i.mergedR > $i.nat; done  # make english test and train files by extracting the second field (after the #)

echo "finished field extraction"

perl -pe 's/ +/\n/g' $NAMELOG-0 | sort -u > vocab.sum1
perl -pe 's/ +/\n/g' $NAMEENG-0 | sort -u > vocab.nat

sed -i '1d' vocab.sum1 # delete space character from vocab
sed -i '1d' vocab.nat

echo "run script training.sh to train, then test.sh to test"

popd

