mkdir -p ~/.ssh/
echo "$DEPLOY_KEY" > ~/.ssh/deploy.key
chmod 600 ~/.ssh/deploy.key
cat >>~/.ssh/config <<END
    Host server
    HostName $DEPLOY_HOST
    User $DEPLOY_USER
    IdentityFile ~/.ssh/deploy.key
    StrictHostKeyChecking no
    Port $DEPLOY_PORT
END