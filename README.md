# Ambiente de desenvolvimento Shopware

TLDR, siga o passo a passo [aqui](#passo-a-passo)

## Pré-requisitos

- Make
- Docker
- repositório de backend
- repositório de frontend

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


# Passo a Passo

## Caso estiver usando windows, tudo deve ser feito dentro do [WSL2](https://medium.com/marcelo-albuquerque/como-instalar-o-wsl-2-no-windows-10-3e26d99d7161).

Antes de começar, certifique-se que você tem os [pré-requisitos](#pré-requisitos).

Clone os repositórios do backend e frontend em um diretório de sua preferencia. Exemplo `/home/user/work/projects/shopware/`

Mude a branch de ambos para `staging`.

## Configurando o `.env`
Seu arquivo `.env` deve ter uma estrutura parecida com essa:

```
SHOPWARE_PATH=/home/user/work/projects/shopware/backend
USERID=$(id -u)
GROUPID=$(id -g)
CLIENT=clientX
PWA_PATH=/home/user/work/projects/shopware/frontend
PWA_AT=
```

Substitua as variaveis *SHOPWARE_PATH* e *PWA_PATH* com o caminho do diretório dos projetos de backend e frontend, respectivamente.
Substitua *CLIENT* pelo nome do cliente no qual você está trabalhando.

## Montando ambiente do backend
Com o ambiente configurado, agora vamos iniciar o processo de montagem.

Dentro do diretório do projeto `DOCKER-DEV-SHOPWARE`, abra um terminal e execute os seguintes comandos:

```
make
```


Este comando deve iniciar os containers e instalar todo o backend.

É normal alguns erros acontecerem durante o processo, pois ainda não terminamos de configurar o frontend.

Para saber se tudo ocorreu como planejado, vamos coletar o ACCESS_TOKEN do backend.

No terminal, execute o seguinte comando:

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


## Montando ambiente do frontend
Agora que nosso backend está todo configurado e nosso `.env` todo preenchido vamos montar o ambiente do frontend.

No terminal, digite esses dois comandos:

```
make down
```
Esse comando deve desmontar todos os conteiners montados anteriormente.
```
make
```
Esse deve subi-los novamente, agora com as configurações corretas.

E em outro terminal:

```
make activatepwa
```

Para ativar o plugin de Pwa no back.


Após isso você deve conseguir acessar os ambientes em: http://localhost/admin e http://localhost:3000 para o backend e frontend respectivamente.

