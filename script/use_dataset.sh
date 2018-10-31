#!/usr/bin/env bash

# Setup /home/{data,config,output} according to .env in given dataset folder

DOTENV=$1

if [ "${DOTENV}" = "" ] || [ ! -f "${DOTENV}" ] ; then
    echo Usage:
    echo $0 DOTENV
    echo Setup symlinks according DOTENV
    echo    ln -sf BDICONFIGFOLDER /home/config
    echo    ln -sf BDIOUTPUTFOLDER /home/output
    echo    ln -sf BDIDATAFOLDER /home/data
    exit 1
fi

in_repo="$(git rev-parse --is-inside-work-tree 2> /dev/null)"
if [ ! "$in_repo" ]; then
   echo You are not in a git repo.
   exit 1
fi

REPO_ROOT=`git rev-parse --show-toplevel`
DEV_CONFIG=${REPO_ROOT}/runtime/config
if [ ! -d "${DEV_CONFIG}" ]; then
    echo No folder runtime/config. Are you in the oxpecker-repo?
    exit 1
fi

BDICONFIGFOLDER=`sed -n -e 's/^BDICONFIGFOLDER=//p' ${DOTENV}`
if [ "${BDICONFIGFOLDER}" = "" ]; then
    echo 'BDICONFIGFOLDER' not set in ${DOTENV}
    exit 1
else
    if [ ! -d "${BDICONFIGFOLDER}" ]; then
        echo BDICONFIGFOLDER points to a folder which does not exist - ${BDICONFIGFOLDER}
        exit 1
    fi
fi

BDIDATAFOLDER=`sed -n -e 's/^BDIDATAFOLDER=//p' ${DOTENV}`
if [ "${BDIDATAFOLDER}" = "" ]; then
    echo 'BDIDATAFOLDER' not set in ${DOTENV}
    exit 1
else
    if [ ! -d "${BDIDATAFOLDER}" ]; then
        echo BDIDATAFOLDER points to a folder which does not exist - ${BDIDATAFOLDER}
        exit 1
    fi
fi

BDIOUTPUTFOLDER=`sed -n -e 's/^BDIOUTPUTFOLDER=//p' ${DOTENV}`
if [ "${BDIOUTPUTFOLDER}" = "" ]; then
    echo 'BDIOUTPUTFOLDER' not set in ${DOTENV}
    exit 1
else
    if [ ! -d "${BDIOUTPUTFOLDER}" ]; then
        echo BDIOUTPUTFOLDER points to a folder which does not exist - ${BDIOUTPUTFOLDER}
        exit 1
    fi
fi

set -eux
cp -rf ${BDICONFIGFOLDER}/* ${DEV_CONFIG}/
rm -f ${DEV_CONFIG}/cluster.json
ln -sf ${BDICONFIGFOLDER} /home/config
ln -sf ${BDIDATAFOLDER} /home/data
ln -sf ${BDIOUTPUTFOLDER} /home/output
