#!/bin/bash

echo "Deploying to SWB"
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export SSHPASS=$DEPLOY_PASS
sshpass -e scp -o stricthostkeychecking=no -P ${DEPLOY_PORT} "${PROJECT_DIR}/git-deploy.sh" ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_HOME}
sshpass -e ssh -o stricthostkeychecking=no -p $DEPLOY_PORT $DEPLOY_USER@$DEPLOY_HOST sudo bash ${DEPLOY_HOME}/git-deploy.sh "${DEPLOY_PATH}" ${TRAVIS_REPO_SLUG} ${TRAVIS_COMMIT}
sshpass -e ssh -tt -o stricthostkeychecking=no -p $DEPLOY_PORT $DEPLOY_USER@$DEPLOY_HOST sudo docker container exec -it ${DEPLOY_CONT} bash -l "deploy.sh"