#!/usr/bin/env bash

set -e

create_config() {
    extrasjs=$(</home/app/config_js_extras)
    modulejs=$(</home/app/config_js_exports)
    echo "${extrasjs}" > shopware-pwa.config.js
    echo "${modulejs/SHOPWARE_ACCESSTOKEN/${SHOPWARE_ACCESSTOKEN}}" >> \
        shopware-pwa.config.js
}

start(){
    cd ${APP_PATH};
    yarn
    yarn shopware-pwa domains --ci
    yarn shopware-pwa plugins
    yarn dev
}

main (){
    APP_PATH=${APP_PATH:-"/home/app/pwa"}
    # SHOPWARE_ENDPOINT=${SHOPWARE_ENDPOINT?"Necessário informar o ENDPOINT"}
    SHOPWARE_ACCESSTOKEN=${SHOPWARE_ACCESSTOKEN?"Necessário informar o ACCESSTOKEN"}
    cd ${APP_PATH}

    create_config;
    start;
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    main;
fi