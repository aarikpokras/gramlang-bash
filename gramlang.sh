#!/bin/bash
if [ -z "$1" ]; then
  echo Please pass a file name.
else
  if [ -f "$1" ]; then
    while IFS= read -r -u 3 i; do
      # Parsing
      if [[ "$i" =~ "say without new line" ]]; then
        printf "$i" | sed 's/say without new line //'
      elif [[ "$i" =~ "evaluate" ]]; then
        expression=$(echo $i | sed 's/evaluate //')
        if [ "$(echo $((expression)) >& /dev/null;echo $?)" -eq 0 ]; then
          echo $((expression))
        else
          echo gramlang: evaluate: syntax error
        fi
      elif [[ "$i" == "@@"* ]]; then
        :
      elif [[ "$i" =~ "pause for" ]]; then
        duration=$(echo $i | sed -e 's/pause for //' -e 's/seconds//')
        sleep $duration
      elif [[ "$i" =~ "say" ]]; then
        echo $i | sed 's/say //'
      elif [[ "$i" == "get machine hardware name" ]]; then
        uname -m
      elif [[ "$i" == "get machine architecture" ]]; then
        uname -p
      elif [[ "$i" =~ "read" ]]; then
        if [ -f "$(echo $i | sed 's/read //')" ]; then
          cat $(echo $i | sed 's/read //')
        else
          echo gramlang: read: no such file $(echo $i | sed 's/read //')
        fi
      elif [[ "$i" =~ "ask" ]]; then
        printf "$(echo $i | sed 's/ask //')"
        read -r var1
        echo $var1 >> gram.out
      fi
    done 3< "$1"
  else
    echo gramlang: $1: No such file
  fi
fi
