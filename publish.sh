#!/bin/bash

if [[ -z $1 || $1 == "-h" ]]; then
   echo "Usage: publish.sh <file.html>"
   exit
fi

PREFIX=$(date +%Y-%m-%d)
NUMPOSTS=$(ls -1 _posts/${PREFIX}* | wc -l)
NEWNAME=${PREFIX}-$(printf "%05i" $(( NUMPOSTS + 1 )) ).html

while [[ -e _posts/$NEWNAME ]]; do
   NUMPOSTS=$(( NUMPOSTS + 1 ))
   NEWNAME=${PREFIX}-$(printf "%05i" $((NUMPOSTS + 1 )) ).html
done

if [[ -e $1 ]]; then
   cp $1 _posts/$NEWNAME
   git add _posts/$NEWNAME
   git commit -m "Afegida automàticament la pàgina $NEWNAME."
   git push

   URL=https://rights4parasites.github.io/$(echo $NEWNAME | sed "s|-|/|g")
   qrencode -s 6 -l H -o "URL.png" "$URL"
   eog URL.png &
else
   echo "Què vols que faça de ${1}?"
   exit
fi

