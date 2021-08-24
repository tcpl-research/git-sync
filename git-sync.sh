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
git config --global pull.rebase true

echo "----------------------------------------------------------------"

git clone "$SOURCE_REPO" --origin source && cd `basename "$SOURCE_REPO" .git`
sleep 10
echo "$SOURCE_REPO  cloned"

git remote add destination $DESTINATION_REPO
sleep 2
echo "remote added $DESTINATION_REPO as destination"

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

git checkout $SOURCE_BRANCH
sleep 4
echo "checked out $SOURCE_BRANCH"

echo "----------------------------------------------------------------"

git pull destination $DESTINATION_BRANCH --allow-unrelated-histories -X ours
sleep 4
echo "pull complete $DESTINATION_REPO $DESTINATION_BRANCH"

#git fetch $DESTINATION_REPO $DESTINATION_BRANCH
#sleep 4
#echo "fetch complete $DESTINATION_REPO $DESTINATION_BRANCH"

echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

if ! echo $FORCE | grep 'true'
  then    
    git push destination $SOURCE_BRANCH:$DESTINATION_BRANCH
    echo "Pushed $SOURCE_BRANCH:$DESTINATION without force"
  else
    git push destination $SOURCE_BRANCH:$DESTINATION_BRANCH  -f
    echo "Pushed $SOURCE_BRANCH:$DESTINATION force"
fi


echo ".........................................................."
