#!/bin/bash
version=$1

if [[ -z "$version" ]]; then
  echo "You should set version"
  exit 1
fi

docker build . -t oleggromov/rushy:${version}
