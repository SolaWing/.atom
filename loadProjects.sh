#!/bin/bash

if [[ -e packages.txt ]]; then
    apm install --packages-file packages.txt
fi
