#!/bin/sh

set -e

SOURCE_REPO=$1
SOURCE_BRANCH=$2
DESTINATION_REPO=$3
DESTINATION_BRANCH=$4
EMAIL=$5
NAME=$6
FORCE=$7

if ! echo $SOURCE_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY" ]]
  then
    SOURCE_REPO="git@github.com:${SOURCE_REPO}.git"
    GIT_SSH_COMMAND="ssh -v"
  else
    SOURCE_REPO="https://github.com/${SOURCE_REPO}.git"
  fi
fi
if ! echo $DESTINATION_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY" ]]
  then
    DESTINATION_REPO="git@github.com:${DESTINATION_REPO}.git"
    GIT_SSH_COMMAND="ssh -v"
  else
    DESTINATION_REPO="https://github.com/${DESTINATION_REPO}.git"
  fi
fi

echo "SOURCE=$SOURCE_REPO:$SOURCE_BRANCH"
echo "DESTINATION=$DESTINATION_REPO:$DESTINATION_BRANCH"

git config --global user.email "$EMAIL"
git config user.email
git config --global user.name "$NAME"
git config user.name 

echo "----------------------------------------------------------------"

git clone "$SOURCE_REPO" --origin source && cd `basename "$SOURCE_REPO" .git`
git remote add destination "$DESTINATION_REPO"
git fetch destination
sleep 1
git remote show destination
sleep 1
echo "==============================================================="
git checkout -b $SOURCE_BRANCH
sleep 1
git pull destination master --allow-unrelated-histories
sleep 4
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
git remote show destination
sleep 1

if ! echo $FORCE | grep 'true'
  then    
    git push destination $SOURCE_BRANCH:$DESTINATION_BRANCH
    echo "Pushed $SOURCE_BRANCH:$DESTINATION without force"
  else
    git push destination $SOURCE_BRANCH:$DESTINATION_BRANCH  -f
    echo "Pushed $SOURCE_BRANCH:$DESTINATION force"
fi


echo ".........................................................."
