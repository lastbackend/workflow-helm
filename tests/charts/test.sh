#!/bin/bash

set -e

gpg --import tests/charts/lastbackend.gpg.asc
for f in $(find tests/charts/ -mindepth 1 -type d); do
  echo ""
  echo "Test $f"
  helm secrets lint charts/app --strict --values $f/values.yml
  helm secrets template --release-name $(basename $f) --values $f/values.yml charts/app > $f/actual.yml
  diff $f/actual.yml $f/expected.yml
done
