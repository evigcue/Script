#!/bin/bash

function suma {
    local n1=$1
    local n2=$2

    local rdo=$(( n1 + n2 ))

    echo $rdo
}

function resta {
    local n1=$1
    local n2=$2

    local rdo=$(( n1 - n2 ))

    echo $rdo
}

function multiplica {
    local n1
    local n2

    read -rp "Deme el primer número: " n1
    read -rp "Deme el segundo número: " n2

    local rdo=$(( n1 * n2 ))

    echo $rdo
}

function divide {
    local n1
    local n2

    read -rp "Deme el primer número: " n1
    read -rp "Deme el segundo número: " n2

    local rdo=$(( n1 / n2 ))

    echo $rdo
}