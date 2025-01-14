From drupal:10.2.1
ARG CERTPATH
RUN mkdir /drupal-site
COPY . /drupal-site/
RUN cp -r /drupal-site /var/www/html/
WORKDIR /var/www/html/drupal-site

RUN php -m

RUN docker-php-ext-install bcmath
#RUN drush cr
#RUN composer update
RUN composer install
# install drush

#RUN apt-get update -y && apt-get install git -y
#RUN composer require drush/drush
#RUN cd /usr/sbin/ && ln -s /var/www/html/drupal-site/vendor/drush/drush/drush drush
#RUN 



COPY sites/default/settings.php /var/www/html/drupal-site/web/sites/default/

RUN cd /etc/apache2/sites-available
RUN rm -Rf 000-default.conf
COPY 000-default.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2
COPY DigiCertGlobalRootCA.crt.pem /etc/apache2/
RUN cd /etc/apache2/sites-enabled
RUN rm -Rf 000-default.conf
COPY 000-default.conf /etc/apache2/sites-enabled/ 
RUN mkdir -p /var/www/html/sites/default/files
RUN chown www-data:www-data /var/www/html/sites/default/files
RUN chmod -Rf 777 /var/www/html/sites
RUN chmod -Rf 777 /var/www/html/drupal-site
RUN cd /var/www/html/drupal-site && vendor/bin/drush --version
RUN cd /var/www/html/drupal-site && vendor/bin/drush cr -vvv
RUN cd /var/www/html/drupal-site && vendor/bin/drush updb --yes -vvv
RUN cd /var/www/html/drupal-site && vendor/bin/drush config:import --yes -vvv
#RUN cd /var/www/html/drupal-site && vendor/bin/drush cr --uri=http://phpdemoapp1-bfdbf2abe9bud3h7.eastasia-01.azurewebsites.net -vvv
#RUN cd /var/www/html/drupal-site && vendor/bin/drush updb --uri=http://phpdemoapp1-bfdbf2abe9bud3h7.eastasia-01.azurewebsites.net -vvv
#RUN cd /var/www/html/drupal-site && vendor/bin/drush cim --uri=http://phpdemoapp1-bfdbf2abe9bud3h7.eastasia-01.azurewebsites.net -vvv

RUN ls -la

EXPOSE 80

CMD apachectl -D FOREGROUND