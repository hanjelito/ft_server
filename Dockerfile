# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: juan-gon <juan-gon@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/05 09:43:38 by juan-gon          #+#    #+#              #
#    Updated: 2020/08/11 20:17:13 by juan-gon         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster


COPY srcs/mysql.sh ./root/
COPY srcs/nginx.conf ./root/
COPY srcs/config.inc.php ./root/
COPY srcs/wordpress.tar.gz ./root/
COPY srcs/wordpress.sql ./root/
COPY srcs/wp-config.php ./root/
COPY srcs/phpMyAdmin.tar.gz ./root/
COPY srcs/nginx-start.sh ./root/

RUN apt-get -y update                           &&\
    apt-get -y upgrade                          &&\
    apt-get -y install nginx                    &&\
    apt-get -y install wget                     &&\
    apt-get -y install default-mysql-server     &&\
    apt-get -y install php                      \
    php-mysql php-fpm                           \
    php-cli php-mbstring php-zip php-gd         


RUN tar xzvf /root/phpMyAdmin.tar.gz                                        &&\
    cp -a /phpMyAdmin-4.9.0.1-all-languages/. /var/www/html/phpmyadmin/     &&\
    mkdir -p /var/lib/phpmyadmin/tmp                                        &&\
    chown -R www-data:www-data /var/lib/phpmyadmin                          &&\
    cp /root/config.inc.php /var/www/html/phpmyadmin/

RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64 &&\
    chmod +x mkcert                             &&\
    mv mkcert /usr/local/bin                    &&\
    mkcert -install


RUN service nginx start                                                     &&\
    cp /root/nginx.conf /etc/nginx/sites-available/localhost                &&\
    ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/    &&\
    rm /etc/nginx/sites-enabled/default

RUN bash root/mysql.sh

RUN tar xzvf /root/wordpress.tar.gz                 &&\
    cp -a /wordpress/. /var/www/html/wordpress      &&\
    chown -R www-data:www-data /var/www/html        &&\
    cp /root/wp-config.php /var/www/html/wordpress/


RUN mkcert localhost                                &&\
    mv localhost.pem /etc/nginx/                    &&\
    mv localhost-key.pem /etc/nginx/

EXPOSE 80 443


CMD bash root/nginx-start.sh