# Ambiente de desenvolvimento Shopware

TLDR, siga o passo a passo [aqui](#passo-a-passo)

## Pré-requisitos

- Make
- Docker
- caminho local para um repositório de backend
- caminho local para o um repositório de frontend

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

### Passos adicionais

Ao subir o ambiente pela primeira vez, pode ser necessário em outro terminal usar os seguintes comandos:

```
make get_pwaat
```

Para coletar a access token do backend após oback ter subido, só então você configura em o **PWA_AT** em `.env`.

```
make activatepwa
```
Para ativar o plugin SwagShopwarePwa.

## Encerrando o ambiente

```
make down
```

### Passo a Passo

Baixar os repositórios de backend e de frontend, e pegar o caminho deles, **se estiver usando windows** já baixa no WSL, pois o caminho terá que ser ajustado de acordo com o caminho do WSL.

Configurar o `.env` substituindo os caminhos do front e do back, bem como ajustar os branchs de cada repositório com o ambiente de desenvolvimento (normalmente _staging_), por exemplo digamos que baixei o backend e frontend nas pastas `/home/user/work/projects/shopware/backend` e `/home/user/work/projects/shopware/frontend` respectivamente.
Configurar também o nome do cliente, por exemplo digamos que neste caso meu cliente é **clientX**

```
SHOPWARE_PATH=/home/user/work/projects/shopware/backend
USERID=$(id -u)
GROUPID=$(id -g)
CLIENT=clientX
PWA_PATH=/home/user/work/projects/shopware/frontend
PWA_AT=
```

Após isso executar:

```
make
```

Este comando deve iniciar os containers e instalar todo o backend. Após o backend ser instalado totalmente, é possível coletar o ACCESS_TOKEN com o comando: `make get_pwaat`

```
make get_pwaat
+----------------------------+
| AABBCCDDEEFFGGHHIIJJKKLLMM |
+----------------------------+
```

Este valor deve ser preenchido no `.env` em *PWA_AT*. Exemplo:

```
PWA_AT=AABBCCDDEEFFGGHHIIJJKKLLMM
```

Após isso executar:

```
make down
make
```

E em outro terminal:

```
make activatepwa
```

Para ativar o plugin de Pwa no back.

Após isso você deve conseguir acessar os ambientes em: http://localhost e http://localhost:3000 para o backend e frontend respectivamente.


