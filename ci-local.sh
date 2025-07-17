#!/bin/bash

# if act is not installed, exit and tell the user to install it
if ! command -v act &> /dev/null; then
  echo "act is not installed. Please install it first with 'brew install act' or your preferred method."
  exit 1
fi

# If docker isn't running, exit and tell the user to start it
if ! docker info &> /dev/null; then
  echo "Docker is not running. Please start Docker before running this script."
  exit 1
fi

for ruby_version in 3.0 3.1 3.2 3.3 3.4; do
  echo "Testing Ruby $ruby_version with act..."
  act -j test --matrix ruby-version:$ruby_version
done

echo "🎉 All Ruby versions tested!"
