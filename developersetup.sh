#!/usr/bin/env bash

mkdir deploy
cd deploy
git clone git@github.com:cryoem-uoft/cryosparc-public.git
git clone git@github.com:cryoem-uoft/cryosparc-package.git
cd cryosparc-package
./install.sh --developer --port=3000
cd ../
git clone git@github.com:cryoem-uoft/cryosparc-deploy-tools.git
cd cryosparc-deploy-tools
./deploy.sh --setup
cd ../