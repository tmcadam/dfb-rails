#!/bin/bash

echo "Deploying to Webfaction"

if [ ${1} = "staging" ];
then
    echo "Deploying to staging server"
    set DEPLOY_PATH=$DEPLOY_PATH_STAGING
    set DEPLOY_BRANCH=$DEPLOY_BRANCH_STAGING
else
    echo "Deploying to production server"
fi

export SSHPASS=$DEPLOY_PASS
sshpass -e ssh -o stricthostkeychecking=no ${DEPLOY_USER}@${DEPLOY_HOST} bash "${DEPLOY_HOME}/git_deploy.sh" "${DEPLOY_PATH}" ${DEPLOY_REPO} ${DEPLOY_BRANCH}
sshpass -e ssh -o stricthostkeychecking=no $DEPLOY_USER@$DEPLOY_HOST bash "${DEPLOY_PATH}/deploy.sh"

echo "Webfaction deployment successful"
