#!/bin/bash

if [ ${1} == "staging" ] then
    set DEPLOY_PATH=$DEPLOY_PATH_STAGING
    set DEPLOY_BRANCH=$DEPLOY_BRANCH_STAGING
fi

export SSHPASS=$DEPLOY_PASS
sshpass -e ssh -o stricthostkeychecking=no ${DEPLOY_USER}@${DEPLOY_HOST} bash "${DEPLOY_HOME}/git_deploy.sh" "${DEPLOY_PATH}" ${DEPLOY_REPO} ${DEPLOY_BRANCH}
sshpass -e ssh -o stricthostkeychecking=no $DEPLOY_USER@$DEPLOY_HOST bash "${DEPLOY_PATH}/deploy.sh"
