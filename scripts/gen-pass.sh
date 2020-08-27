#!/bin/bash

function gen_pass() {
  chars='@#$%&_+='
  { </dev/urandom LC_ALL=C grep -ao '[A-Za-z0-9]' \
    | head -n$((RANDOM % 8 + 9))
    echo ${chars:$((RANDOM % ${#chars}))}   # Random special char.
  } \
  | shuf \
  | tr -d '\n';
  echo
}

for i in 1 2 3 4 5 6 7 8 9
do
  gen_pass
done
