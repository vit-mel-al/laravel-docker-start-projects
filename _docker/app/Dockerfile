FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
      apt-utils \
      libpq-dev \
      libpng-dev \
      libzip-dev \
      zip unzip \
      git \
      mc \
      cron \
      nano \
      curl && \
      docker-php-ext-install pdo pdo_pgsql pgsql && \
      docker-php-ext-install bcmath && \
      docker-php-ext-install gd && \
      docker-php-ext-install zip && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer



COPY ./_docker/app/cron_config /etc/cron.d/cron_config
RUN chmod 0644 /etc/cron.d/cron_config
RUN crontab /etc/cron.d/cron_config
RUN touch /var/log/cron.log
#CMD cron && tail -f /var/log/cron.log
EXPOSE 9000
CMD bash -c "cron && php-fpm"