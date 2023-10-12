#!/bin/sh

git remote get-url upstream > /dev/null 2>&1 || git remote add upstream git@github.com:JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module.git
git fetch upstream
git rebase upstream/main
