# Usa a versão enxuta do Debian
FROM debian:bookworm-slim

# Evita perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instala dependências básicas para adicionar o repositório do PHP
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    nano \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# 2. Adiciona a chave GPG e o repositório oficial do PHP (Sury)
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# 3. Instala o PHP 8.2, Apache e as extensões que o Prodmais exige
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-cgi \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-zip \
    php8.2-xml \
    apache2 \
    libapache2-mod-php8.2 \
    && rm -rf /var/lib/apt/lists/*

# 4. Habilita o mod_rewrite do Apache
RUN a2enmod rewrite

# 5. Configura o Apache para permitir o AllowOverride All (necessário para o .htaccess)
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

COPY ./app /var/www/html
WORKDIR /var/www/html

# Expõe a porta 80 para o mundo exterior
EXPOSE 80

# Inicia o Apache em primeiro plano (essencial para o container não fechar)
CMD ["apachectl", "-D", "FOREGROUND"]