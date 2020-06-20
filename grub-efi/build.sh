#!/bin/bash

WORKSPACE="${HOME}/Documents"
OUTPUT="grub-efi-bootarm.efi"

# Use the GitHub API to get the most recent commit details
GIT_MESSAGE=$(curl -s 'https://api.github.com/repos/eigendude/grub/commits' | jq -r '.[0].commit.message')
SHA=$(curl -s 'https://api.github.com/repos/eigendude/grub/commits' | jq -r '.[0].sha')

VERBOSE=1 ${WORKSPACE}/grub-mender-grubenv/grub-efi/docker-create-grub-efi-binaries

echo
echo "Build successful"
echo "Copying binary to meta-mender layer..."
echo

cp \
  "${WORKSPACE}/grub-mender-grubenv/grub-efi/output/${OUTPUT}" \
  "${WORKSPACE}/meta-mender/meta-mender-core/recipes-bsp/grub/files/${OUTPUT}"

cd "${WORKSPACE}/meta-mender"
  echo "Adding to git..."
  git add .
  echo
  git commit -m "Update ${OUTPUT}" \
                \
             -m "Latest commit (${SHA}):" \
                \
             -m "${GIT_MESSAGE}"
  git log -1 --no-decorate
  echo

  echo "Pushing to git..."
  echo
  git push
  echo
cd ..

echo "Done"
