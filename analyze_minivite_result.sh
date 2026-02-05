#!/bin/bash

echo "Running miniVite with 8, 32, and 64 processes"
echo "----------------------------------------"
echo "Running with 8 processes"
grep  "Remote community map size" result/output/minivite_result8.txt  | tail -8
grep  "Modularity" result/output/minivite_result8.txt | tail -1

echo "----------------------------------------"
echo "Running with 32 processes"
grep "Remote community map size" result/output/minivite_result32.txt  | tail -32
grep "Modularity" result/output/minivite_result32.txt  | tail -1
echo "----------------------------------------"
echo "Running with 64 processes"
grep  "Remote community map size"  result/output/minivite_result64.txt | tail -64
grep  "Modularity" result/output/minivite_result64.txt | tail -1
