#!/bin/bash

export HOME=/home/builder

echo '::group::Adding aur.archlinux.org to known hosts'
ssh-keyscan -v -t \
"$INPUT_SSH_KEYCAN_TYPES" aur.archlinux.org >>~/.ssh/known_hosts
echo '::endgroup::'

echo '::group::Importing private key'
echo "$INPUT_PRIVATE_SSH_KEY" >~/.ssh/aur
chmod -vR 600 ~/.ssh/aur*
ssh-keygen -vy -f ~/.ssh/aur >~/.ssh/aur.pub
echo '::endgroup::'

echo '::group::Creating checksums of SSH keys'
sha512sum ~/.ssh/aur ~/.ssh/aur.pub
echo '::endgroup::'

echo '::group::Configuring git'
git config --global user.name "$INPUT_GIT_USERNAME"
git config --global user.email "$INPUT_GIT_EMAIL"
echo '::endgroup::'

echo '::group::Testing the SSH connection to AUR'
echo $(ssh aur@aur.archlinux.org help)
cho '::endgroup::'

echo '::group::Pushing'
git remote add aur "ssh://aur@aur.archlinux.org/${$INPUT_PKGNAME}.git"
case "$INPUT_PUSH" in
true)
    case "$INPUT_FORCE" in
    true)
        git push -v --force aur master
        ;;
    false)
        git push -v aur master
        ;;
    *)
        echo "::error::Invalid Value: inputs.force is neither 'true' nor \
        'false': '$INPUT_FORCE'"
        exit 3
        ;;
    esac
    ;;
false)
    echo "::error::Not pushing anything."
    ;;
*)

echo "::error::Invalid Value: inputs.push is neither 'true' nor 'false': \
'$INPUT_PUSH'"
    exit 2
    ;;
esac
echo '::endgroup::'
