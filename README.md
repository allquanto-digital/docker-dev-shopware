# Ambiente de desenvolvimento Shopware

## Pré-requisitos

- Make
- Docker
- caminho local para um repositório de backend

## Configurando o ambiente

Utiliza-se o arquivo `.env` para configurar o ambiente.

### Variáveis Obrigatórias

| Nome | Valor Padrão |Descrição|
|------|--------------|---------|
|SHOPWARE_PATH|/path/to/folder|Caminho para o repositório de backend|
|CLIENT|clientX|nome do cliente (altera o nome dos volumes do docker, persistência de dados)|
|PWA_PATH|/path/to/frontend|Caminho para o repositório de frontend|
|PWA_AT|Não definido|PWA Access Token|

### Variáveis Opcionais

| Nome | Valor Padrão |Descrição|
|------|--------------|---------|
|LOCAL_PORT|Não definido|Porta que o backend irá escutar, se não estiver definido, usará a porta **80** por padrão|
|USERID|$(id -u)|uid padrão para ser usado no container|
|GROUPID|$(id -g)|gid padrão para ser usado no container|
|PMA_PORT|Não definido|Porta que o phpmyadmin deve utilizar, se não estiver definido o valor é: **8080**|
|PWA_PORT|Não definido|Porta que o front deve escutar, o valor padrão é **3000**|

## Subindo o ambiente

```
make up
```

## Encerrando o ambiente

```
make down
```
