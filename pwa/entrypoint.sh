#!/usr/bin/env bash

set -e

create_config() {
    extrasjs=$(</home/app/config_js_extras)
    modulejs=$(</home/app/config_js_exports)
    echo "${extrasjs}" > shopware-pwa.config.js
    echo "${modulejs/SHOPWARE_ACCESSTOKEN/${SHOPWARE_ACCESSTOKEN}}" >> \
        shopware-pwa.config.js
}

wait_domains(){
    while ! yarn shopware-pwa domains --ci &>-; do
        sleep 5
        echo "Aguardando executar domains"
    done
}

plugins(){
    source .env
    yarn shopware-pwa plugins
}

start(){
    cd ${APP_PATH};
    yarn
    wait_domains
    plugins
    yarn dev
}

main (){
    APP_PATH=${APP_PATH:-"/home/app/pwa"}
    
    [[ ${#SHOPWARE_ACCESSTOKEN} == 0 ]] && unset SHOPWARE_ACCESSTOKEN;
    SHOPWARE_ACCESSTOKEN=${SHOPWARE_ACCESSTOKEN?"Necessário informar o ACCESSTOKEN"}
    
    cd ${APP_PATH}

    create_config;
    start;
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    main;
fi