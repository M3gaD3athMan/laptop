#!/bin/zsh

# Use `~/.aws/credentials` as the source of truth. Always export from there, so the file is updated first
# Please add these to your .zshrc or equivalent
#
# export AWS_ACCESS_KEY_ID=$(sed -n 2p ~/.aws/credentials | sed 's/.*=//g')
# export AWS_SECRET_ACCESS_KEY=$(sed -n 3p ~/.aws/credentials | sed 's/.*=//g')

set -eo pipefail
echo " 🔐 Initiating AWS auth through Vault 🔐 "

if [ -z "$GIT_TOKEN" ]; then
  echo >&2 'error: missing GIT_TOKEN environment variable. Create one here: https://github.com/settings/tokens' && exit 1
fi

if [ -z "$VAULT_ADDR" ]; then
  echo -e "\nexport VAULT_ADDR=https://vault.corvusinsurance.com" >> ~/.zshrc
fi

vault login -method=github token=$GIT_TOKEN
vault read aws/creds/dev > temp

cat ./temp

export AWS_ACCESS_KEY_ID=$(sed -n 6p temp | sed 's/.* //g')
export AWS_SECRET_ACCESS_KEY=$(sed -n 7p temp | sed 's/.* //g')

echo "\nWriting to .aws/credentials…"

mkdir -p ~/.aws
touch ~/.aws/credentials

cp ~/.aws/credentials ~/.aws/deprecated_creds

cat >~/.aws/credentials <<EOF
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
EOF


rm ./temp

echo "🎉 Successfully updated your AWS creds. 🎉 \n"
