#!/bin/bash

if [ -z "$1" ]; then
  echo "ERROR: student's CSE 130 account must be provided"
  exit 1
fi

student=$(grep "$1" students)
num=$(wc -l <<< "$student")

if [ "$num" -eq 0 ]; then
  echo "ERROR: '$1' doesn't identify any students"
  exit 1
elif [ "$num" -gt 1 ]; then
  echo "ERROR: '$1' identifies more than one student"
  exit 1
fi

acc=$(awk '{print $1}' <<< "$student")
name=$(awk '{print $3" "$2}' <<< "$student")
pid=$(awk '{print $4}' <<< "$student")
grade=$(grep "$acc" log.00 | grep -o -E '[0-9]+\/[0-9]+')

if ! [ -z "$grade" ]; then
  echo "$acc ($pid): $grade"
  convert -density 72 blank.pdf -pointsize 12 -draw " \
    text 100,100 'Name: $name' \
    text 100,120 'PID: $pid' \
    text 100,140 'CSE 130 Account: $acc' \
    text 100,160 'Grade: $grade' \
  " "${acc}-grade.pdf"
else
  echo "ERROR: no submission for student $acc"
  exit 1
fi
