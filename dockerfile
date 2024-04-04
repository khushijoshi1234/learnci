FROM php:8.0-apache

#current working directory in the container
WORKDIR /var/www/html/
COPY . /var/www/html/
# Update and upgrade packages, install Git, Zip, and Unzip
RUN apt-get update && \
    apt-get upgrade -y git zip unzip
RUN apt-get install -y unzip libzip-dev
RUN apt-get install -y default-mysql-client
RUN docker-php-ext-install pdo_mysql zip



#Download and install Composer
    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer



#RUN composer install         
RUN composer install --optimize-autoloader
RUN composer update --no-scripts
                 
#change ownership of application directory
RUN chown www-data:www-data /var/www/html



# Optimizing Configuration loading
RUN php artisan config:clear
# Optimizing Route loading
RUN php artisan cache:clear
RUN php artisan view:cache

RUN php artisan key:generate
 

CMD ["sh",  "-c", "php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000 "]
  
