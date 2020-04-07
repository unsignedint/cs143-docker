#!/bin/bash
set -e

STUDENT_FILE=${1:-"https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz"}
ASSIGNMENT_DIR=assignments

# rebuild the container with a new dist file, if it doesn't exist
if [[ -d ".student-dist" ]]; then
  echo "The \`.student-dist\` directory already exists. Not going to download again."
else
  rm -rf .student-dist*
  mkdir .student-dist
  wget "$STUDENT_FILE" -O student-dist.tar.gz
  tar xf student-dist.tar.gz -C .student-dist
fi

# docker stuff, always force a rebuild
docker rmi -f cs143
docker build -t cs143 .

# prepare assignment workspace, if it doesn't exist
if [[ -d "$ASSIGNMENT_DIR" ]]; then
  echo "The \`$ASSIGNMENT_DIR\` directory already exists. Not touching."
else
  cp -r .student-dist/assignments $ASSIGNMENT_DIR
fi
