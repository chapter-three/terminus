#!/bin/bash

set -ex

# Basic lint test
if [[ ! $TRAVIS_COMMIT ]]; then
  TRAVIS_COMMIT=$( git log --format=oneline | head -n1 | awk '{print $1}' )
fi

for f in $( git diff-tree $TRAVIS_COMMIT --name-status -r | grep php | grep -v "^D" | awk '{print $2}') ; do php -l $f ; done

./scripts/lint.sh

# Run the functional tests
behat_cmd="vendor/bin/behat -c=tests/config/behat.yml --suite="
behat_cmd_10="vendor/bin/behat -c=tests/config/behat.yml --suite="
if [ ! -z $1 ]; then
  behat_cmd+=$1
  behat_cmd_10+=$1+"_10"
else
  behat_cmd+="default"
  behat_cmd_10+="default_10"
fi
if [ -z $2 ]; then
  # Run the unit tests if we are not targeting a feature
  vendor/bin/phpunit -c tests/config/phpunit.xml.dist --debug
  vendor/bin/phpunit -c tests/config/phpunit-10.xml.dist --debug
fi
eval $behat_cmd
eval $behat_cmd_10
