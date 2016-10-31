#!/bin/bash

count1=3
count2=4

count3=$((count1+count2))

((count2+=count1))

echo $count3

echo $count2