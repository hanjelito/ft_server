rm -rf /phpMyAdmin-4.9.0.1-all-languages/
rm -rf /wordpress/
service php7.3-fpm start
service mysql restart
service nginx restart
# tail -f /dev/null
sleep infinity & wait
