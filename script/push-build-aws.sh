#!/usr/bin/env bash

# Push this branch to origin, update the personal pipeline and trigger it.


in_repo="$(git rev-parse --is-inside-work-tree 2> /dev/null)"
if [ ! "$in_repo" ]; then
   echo You are not in a git repo.
   exit 1
fi


set -eux

git push -u origin HEAD

export REPO_ROOT=`git rev-parse --show-toplevel`
pushd ${REPO_ROOT}/utils/aws_codepipeline

export BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
./create-codepipeline.sh -t aoh -b ${BRANCH_NAME} -u

popd

aws codepipeline start-pipeline-execution --name aoh-personal-pipeline
