#!/bin/bash

if [[ "$2" == *UrbanDaddy* ]]; then
  ssh -i ~/.ssh/mstaugler-ud $@
else
  ssh -i ~/.ssh/id_rsa $@
fi
