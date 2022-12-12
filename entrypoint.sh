#!/usr/bin/env bash

APP_PATH=./shopware

create_environment(){
    echo -e "Filling Environment Values:\n\n"
    echo "# Do not change this file, this is generated file, and" | \
        tee -a .env && \
    echo "# all changes will be lost" | tee -a .env && \
    echo "APP_ENV=\"dev\"" | tee -a .env && \
    echo "APP_SECRET=\"1\""  | tee -a .env && \
    echo "INSTANCE_ID=\"1\""  | tee -a .env && \
    echo "DATABASE_URL=\"${DATABASE_URL}\""  | tee -a .env && \
    echo "APP_URL=\"http://localhost\""  | tee -a .env && \
    echo "MAILER_URL=\"smtp://localhost:1025\"" | tee -a .env && \
    echo "COMPOSER_HOME=\"/var/cache/composer\""| tee -a .env && \
    echo "SHOPWARE_ES_ENABLED=\"0\""| tee -a .env
    echo -e "\n\n"
}

environment_exists(){
    [ -r .env ] && grep -q DATABASE_URL .env
}

show_n_execute() {
    local -a args
    args=($@)
    echo -e "============> Executing: \n\t${args[@]}\n";
    ${args[@]}
}

pre_install(){
    show_n_execute composer install \
        --no-interaction --optimize-autoloader --no-scripts
     show_n_execute composer install \
        --working-dir vendor/shopware/recovery \
        --no-interaction --no-scripts
    show_n_execute composer install \
        --working-dir=vendor/shopware/recovery/Common \
        --no-interaction \
        --optimize-autoloader --no-suggest
}

get_db_access_data(){
    DBRGX="(.*)://([^:]*):([^@]*)@([^:]*):([^/]*)/(.*)"
    [[ ${DATABASE_URL} =~ ${DBRGX} ]]
    read -r DB_PROTOCOL DB_USER DB_PASSWORD DB_HOST DB_PORT DB_DBNAME \
        <<<$(echo ${BASH_REMATCH[@]:1})
}

install_shopware() {
    rm -f install.lock
    echo -e "===> INSTALANDO SHOPWARE"
    show_n_execute bin/ci system:install \
        --shop-locale=${SHPW_LANGUAGE:-"de-DE"} \
        --shop-currency=${SHPW_CURRENCY:-"CHF"} \
        --create-database --basic-setup
    echo -e "===> CONCLUÍDO"
}

wait_mysql(){
    local host;
    local port;
    host=${1?-"Missing argument hostname"}
    port=${2:-3306}
    while ! ( echo > /dev/tcp/${host}/${port}) 2>/dev/null; do
        echo -e "Aguardado MySQL($host:$port)"
        sleep 1;
    done
}

database_exists(){
    mysql -u${DB_USER} -p${DB_PASSWORD} -h${DB_HOST} ${DB_DBNAME} \
        -Ne "SELECT 1 FROM version" &>/dev/null 2>&1
}

main(){
    local -a args
    args=($@)

    cd ${APP_PATH}

    pre_install;
    if ! environment_exists; then
        create_environment
    fi
    
    source .env
    get_db_access_data;
    wait_mysql "${DB_HOST}" "${DB_PORT}"

    if database_exists; then
        local -a commands
        commands=(
            "bin/ci system:generate-jwt-secret"
            "bin/ci dal:refresh:index"
            "bin/ci assets:install"
            "bin/ci theme:compile"
        )
    else
        install_shopware
        show_n_execute bin/ci system:generate-jwt-secret
    fi

    show_n_execute bin/ci cache:clear
    :>install.lock

    exec apachectl -DFOREGROUND
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    # set -x
    main $@;
fi