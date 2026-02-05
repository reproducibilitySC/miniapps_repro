#!/bin/bash
mkdir -p minivite_input
cd minivite_input
if ! [ -f neuron1024.tar.gz ]; then
  wget https://graphchallenge.s3.amazonaws.com/synthetic/sparsechallenge_2019/dnn/neuron1024.tar.gz
fi
if ! [ -d neuron1024 ]; then
  tar -xvzf neuron1024.tar.gz
fi


cd neuron1024
if ! [ -f neuron1024.tsv ]; then
  cat *.tsv > neuron1024.tsv
fi

cd ..


if ! [ -d vite ]; then
  git clone https://github.com/ECP-ExaGraph/vite.git
fi


cd vite
module load openmpi

make

bin/./fileConvert -u -f ../neuron1024/neuron1024.tsv -o .././neuron1024.bin

cd ..

if ! [ -f neuron1024.bin ]; then
  echo "neuron1024.bin not found"
  exit 1
else
  echo "neuron1024.bin found"
  echo ${PWD}
  cp neuron1024.bin ../result/input/
  
fi

