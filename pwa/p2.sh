#!/usr/bin/env bash

# set -e

create_pwa(){
    # npx @shopware-pwa/cli@latest \
    npx @shopware-pwa/cli@1.4.0 \
        init --ci --devMode \
        --shopwareEndpoint=http://localhost \
        --shopwareDomainsAllowList=http://localhost \
        --shopwareDomainsAllowList=http:/localhost/de \
        --shopwareAccessToken=${SHOPWARE_ACCESSTOKEN} \
        --username admin \
        --password shopware
    yarn shopware-pwa domains --ci
    yarn build
}

domains(){
    yarn shopware-pwa domains --ci
}

start_pwa(){
    # yarn run shopware-pwa dev
    yarn start
}

main (){
    APP_PATH=${APP_PATH:-"/home/app/pwa2"}

    [[ ${#SHOPWARE_ACCESSTOKEN} == 0 ]] && unset SHOPWARE_ACCESSTOKEN;
    SHOPWARE_ACCESSTOKEN=${SHOPWARE_ACCESSTOKEN?"Necessário informar o ACCESSTOKEN"}

    mkdir -p ${APP_PATH}
    cd ${APP_PATH}

    create_pwa;
    sleep 9999
    # domains;
    # start_pwa;
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    main;
fi