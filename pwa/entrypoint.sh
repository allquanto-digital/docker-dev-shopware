#!/usr/bin/env bash

set -e

start(){
    cd ${APP_PATH};
    yarn
    yarn shopware-pwa domains --ci
    yarn build
    yarn start
}

main (){
    APP_PATH=${APP_PATH:-"/home/app/pwa"}
    # SHOPWARE_ENDPOINT=${SHOPWARE_ENDPOINT?"Necessário informar o ENDPOINT"}
    # SHOPWARE_ACCESSTOKEN=${SHOPWARE_ACCESSTOKEN?"Necessário informar o ACCESSTOKEN"}

    # create_config;
    start;
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    main;
fi