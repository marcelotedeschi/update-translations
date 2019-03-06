#!/bin/bash

# Script to automate phraseapp translations workflow
#  1. Checks the branch to master stashing changes
#  2. Creates new update-translations/[date] branch
#  3. Pulls changes from Phraseapp translations
#  4. Adds commit, pushes to remote and creates pull request
# Instructions: Run script from the project directory

update_translations() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$BRANCH" != "master" ]]; then
    echo 'Git branch not in master. Your current changes will be stashed'
    read -p "Do you want to checkout to master? (y|n): " answer
    if [[ "$answer" == "y" ]]; then
      if [[ `git status --porcelain` ]]; then
        echo "Stashing changes:"
        git stash
      fi
      echo "Checkout to master branch:"
      git checkout master
    else
      echo "Aborted, please checkout to master and try again."
      exit 1
    fi
  fi

  if [[ `git status --porcelain` ]]; then
    echo "Stashing changes:"
    git stash
  fi

  echo "Pull lastest changes:"
  git pull

  today=`date +%s`
  echo "Creating new branch update-translations/$today"
  git checkout -b update-translations/$today

  echo "Pulling translations..."
  phraseapp pull

  echo "Translations were pulled!"
  read -p "You can make changes while I wait. Continue? (y|n): " answer2

  if [[ "$answer2" == "n" ]]; then
    echo "Aborted"
    exit 1
  fi

  echo "Adding commit:"
  git add . && git commit -m "Update translations $today"

  echo "Pushing to origin"
  git push origin HEAD

  if [[ -x "$(command -v hub)" ]]; then
    echo 'Creating pull request:'
    hub pull-request --no-edit --labels 'needs review'
  else
    echo 'You do not seem to have hub. To create pull requests automatically,
          please install hub! For now, your branch is pushed :)'
    echo 'https://hub.github.com/'
    exit 1
  fi

  echo 'All done !!'
  exit 0
}

# Run function
update_translations
