#!/bin/bash

declare -a users

while IFS=':' read -r user group home shell; do
    if ! getent $user; then
        ${users[]}
    fi
done