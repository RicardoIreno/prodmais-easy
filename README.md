# 5 Passos para uma instalação fácil do Prodmais

Para rodar o Prodmais em um container será preciso o Docker ou o Podman instalados.

Instruções do Docker:
   - Para Windows, é recomendável a utilização do subsistema Linux WSL. Veja mais informações em  https://docs.docker.com/desktop/setup/install/windows-install/
   - Para Linux veja: https://docs.docker.com/desktop/setup/install/linux/


Esta estrutura contem:

```
.
├── app/
├── certs/
├── .env
├── docker-compose.yml
├── Dockerfile
└── README.md
```

### 1. Baixe os arquivos do Prodmais

O primeiro passo é baixar os arquivos do prodmais no Github. Baixe o conteúdo dentro da pasta app.

```sh
cd /app

git clone https://github.com/unifesp/prodmais.git .
```

### 2. Configure as variáveis

As variáveis do Prodmais estão no arquivo `app/inc/config.php`, porem este arquivo não existe exatamente com esse nome. Procure pelo arquivo `app/inc/config_example.php` e nemoeie-o. 

Altere as variáveis:
- `$hosts`
- `$elasticsearch_user`
- `$elasticsearch_password`

Seus valores devem ser idênticos aos configurados no arquivo `.env`:
- `ELASTICSEARCH_HOSTS`¹
- `ELASTICSEARCH_USERNAME`
- `ELASTIC_PASSWORD`


 ¹com a diferença de que, em `hosts`, ela deve estar sem "http://", e dentro de um array.


Exemplo:

```sh
# .env
ELASTICSEARCH_URL=http://esprodmais:9200
ELASTICSEARCH_HOSTS=http://prod_es:9200

# ./inc/config.php
$hosts = ['esprodmais:9200'];
```

> Caso não queria utilizar as credenciais, comente-as no docker-compose.yml e altere o valor de `xpack.security.enabled` para `false`.


### 3. Altere em `setCABundle` em `app/inc/functions.php`, na linha 22

Esta variável deve ficar igual ao exemplo abaixo:

```
>setCABundle('/var/www/html/inc/http_ca.crt')
```

### 4. Construa o container (build)

Na pasta raiz, faça o comando (pelo terminal)

```sh
docker compose up -d
```

### 5. Configurações dentro do container rodando

Os comandos seguintes não funcionam no Dockerfile, será preciso executá-los após a construção do container.

```
docker exec -it prod_app bash
```

Agora você está dentro do container prodmais1, o terminal deve ter mudado para algo como:

```
root@6189419b1bec:/var/www/html# 
```

Rode os comandos:

```sh

curl -s https://getcomposer.org/installer | php

php composer.phar install --no-dev
```

### Você já pode acessar o Prodmais pelo navegador

Acesse o endereço [http://localhost:8080/](http://localhost:8080/). Como não há carga de dados, a tela inicial exibe a mensagem " O Prod+ está em manutenção!". Para inserir dados, clique em "Inclusão", no rodapé.



## Instalação *bare metal*

É altamente recomendável a instalação via, mas caso queira isntalar de forma *bare metal*, (no próprio sistema), será preciso um sistema Linux baseadop em Debian. Os primeiros passos são a execução dos comandos já scriptados no Dockerfile, basta copiá-los na ordem, sem as partes `RUN` que precedem cada comando, dado que esses são comandos do Docker, mas adicionando o `sudo` necessário para rodar a maioria dos comandos no Linux.

Exemplo:
```bash
# o comando
RUN apt-get update && apt-get install -y \ ...

#deve ficar 
sudo apt-get update && apt-get install -y \
```



