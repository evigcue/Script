#!/bin/bash

function suma {
    local n1=$1
    local n2=$2

    local rdo=$(( n1 + n2 ))

    echo $rdo
}