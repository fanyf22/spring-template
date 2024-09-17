#!/bin/sh

#
# MIT License
#
# Copyright (c) 2024. Philip Fan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# This script is used to build the docker image
# Reads environment variables:
# - DOCKER_IMAGE: the name of the docker image
# - REPO_URL: the URL of the repository
# - REPO_USERNAME: the username of the repository
# - REPO_PASSWORD: the password of the repository

# Get the script name
name=$(basename "$0")

# Logging
echo "$name: checking if the required environment variables are set"

# Check if the DOCKER_IMAGE is set
if [ -z "$DOCKER_IMAGE" ]; then
  echo "error: $name: DOCKER_IMAGE is not set" >&2
  exit 1
fi

# Check if the REPO_URL is set
if [ -z "$REPO_URL" ]; then
  echo "error: $name: REPO_URL is not set" >&2
  exit 1
fi

# Check if the REPO_USERNAME is set
if [ -z "$REPO_USERNAME" ]; then
  echo "error: $name: REPO_USERNAME is not set" >&2
  exit 1
fi

# Check if the REPO_PASSWORD is set
if [ -z "$REPO_PASSWORD" ]; then
  echo "error: $name: REPO_PASSWORD is not set" >&2
  exit 1
fi

# Logging
echo "$name: creating temporary files for the secrets"

# Create temporary files for the secrets
repo_url_file=$(mktemp)
repo_username_file=$(mktemp)
repo_password_file=$(mktemp)

# Write the secrets to the temporary files
printf "%s" "$REPO_URL" > "$repo_url_file"
printf "%s" "$REPO_USERNAME" > "$repo_username_file"
printf "%s" "$REPO_PASSWORD" > "$repo_password_file"

# Logging
echo "$name: building the docker image"

# Build the docker image
docker build \
  --secret id=repo_url,src="$repo_url_file" \
  --secret id=repo_username,src="$repo_username_file" \
  --secret id=repo_password,src="$repo_password_file" \
  -t "$DOCKER_IMAGE" .

# Loggings
echo "$name: removing the temporary files"

# Remove the temporary files
rm "$repo_url_file"
rm "$repo_username_file"
rm "$repo_password_file"
