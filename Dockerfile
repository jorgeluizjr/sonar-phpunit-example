FROM ubuntu 

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y wget software-properties-common gnupg2 curl php-zip unzip php-xdebug php-mbstring php-xml  && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php5.6 && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    HASH="$(wget -q -O - https://composer.github.io/installer.sig)" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    echo "chmod 777 -R  ./vendor" >> /entrypoint.sh && \
    echo "composer require --dev phpunit/phpunit ^5.6" >> /entrypoint.sh && \
    echo "phpunit --configuration ./phpunit.xml.dist" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh 

ENV PATH=$PATH:/opt/vendor/bin

ENTRYPOINT /entrypoint.sh
