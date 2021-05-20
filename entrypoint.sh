#!/bin/bash

# Set path
WORKPATH=$GITHUB_WORKSPACE
if [[ -n "$INPUT_PATH" ]]; then
    WORKPATH=$INPUT_PATH
fi

# Set path permision
sudo chown -R builder $WORKPATH
cp $GITHUB_WORKSPACE/scripts /.
cd $WORKPATH

echo '::group::Initializing ~/.ssh directory'
mkdir -pv /home/builder/.ssh
touch /home/builder/.ssh/known_hosts
cp -v $GITHUB_WORKSPACE/.ssh/config /home/builder/.ssh/config
chown -vR builder:builder /home/builder
chmod -vR 600 /home/builder/.ssh/*
echo '::endgroup::'

exec runuser builder --command 'bash -l -c scripts/git.sh'
