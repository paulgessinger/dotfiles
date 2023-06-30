#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
        scutil --get ComputerName| tr -d "\n"
else
        echo -n $HOSTNAME
fi
