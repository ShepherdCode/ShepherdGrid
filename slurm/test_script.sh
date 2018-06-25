#!/bin/sh

#SBATCH -c 1
#SBATCH -o test.out

echo uname
uname -a

echo
echo date
date

echo
echo df
df

exit 0
