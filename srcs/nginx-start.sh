rm -rf /phpMyAdmin-4.9.0.1-all-languages/
rm -rf /wordpress/
service nginx restart
service mysql restart
service php7.3-fpm start
# tail -f /dev/null
sleep infinity & wait
