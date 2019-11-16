#!/usr/bin/env bash
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ $BRANCH == "master" ]
then
  read -p  "Do you want to update master to the baseline tag (Y/N)?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "Setting current master as baseline tag"
    git tag  -d baseline
    git push origin :refs/tags/baseline
    git tag baseline
    git push origin baseline
  fi
else
  echo "Your current branch is not master, please run this script from master"
  exit 1
fi