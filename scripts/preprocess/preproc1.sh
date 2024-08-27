#!/bin/bash

NAME=outKindaSmall

NAMELOG=$NAME-log.txt
NAMEENG=$NAME-eng.txt


perl -pe 's/,/ , /g; s/ +/ /g;' $NAMEENG > $NAMEENG-0 

perl -pe 's/([()?])/ $1 /g; s/ +/ /g;' $NAMELOG > $NAMELOG-0

paste -d\# $NAMELOG-0 $NAMEENG-0 > out.merged
shuf < out.merged > out.mergedR
split -l 49000 out.mergedR
mv xaa train.mergedR
mv xab bigtest.mergedR
head -n 200 bigtest.mergedR > dev.mergedR
tail -n 200 bigtest.mergedR > test.mergedR
for i in bigtest dev test train; do cut -f1 -d\# $i.mergedR > $i.sum1; done
for i in bigtest dev test train; do cut -f2- -d\# $i.mergedR > $i.nat; done
perl -pe 's/ +/\n/g' $NAMELOG-0 | sort -u > vocab.sum1
perl -pe 's/ +/\n/g' $NAMEENG-0 | sort -u > vocab.nat
# emacs vocab.nat
# emacs vocab.sum1
