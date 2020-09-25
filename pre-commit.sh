#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".
# pre-commit.sh
STASH_NAME="pre-commit-$(date +%s)"
git stash save -q --keep-index $STASH_NAME

echo "running pre commit"

# Test prospective commit
num_notebooks=`git diff --cached --name-only | grep  -c .ipynb`
notebooks=`git diff --cached --name-only | grep  .ipynb`

if [ ${num_notebooks} -eq 0 ]; then
     echo "No notebooks"
 else
     python test_and_clear_notebooks.py $notebooks
 fi
git add -u .


STASHES=$(git stash list)
if [[ $STASHES == "$STASH_NAME" ]]; then
  git stash pop -q
fi

