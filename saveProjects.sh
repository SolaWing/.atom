#!/bin/bash

apm list --installed --bare > packages.txt
git add "packages.txt"
