#!/bin/bash
required_version=17.6.0
nvm install $required_version
nvm use $required_version
make site_clean
make site_install
make site_dev

