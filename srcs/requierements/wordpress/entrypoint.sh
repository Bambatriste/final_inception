cd /var/www/html
mv /wp-config.php .

#until mysqladmin -hmariadb -u${SQL_ROOT_USER} -p{$SQL_ROOT_PWD} ping && mariadb -hmariadb -u${SQL_ROOT_USER} -p${SQL_ROOT_PWD} -e "SHOW DATABASES;" | grep ${SQL_DB};do
#	sleep 2
#done

cat .wordpress_installed 2> /dev/null;
if [ $? -ne 0 ];then
  touch .wordpress_installed;
  wp core download --allow-root;
  wp core install --allow-root --url="aedouard.42.fr" --title="first website" --admin_user="${SQL_ROOT_USER}" --admin_password="${SQL_ROOT_PWD}" --admin_email="bonjour1234@hotmail.fr" --skip-email;
  wp user create bob bob@example.com --role=author --user_pass="${SQL_BASIC_PWD}" --allow-root
  echo "WORDPRESS INSTALLED";
fi

##until mysqladmin -hmariadb -u${SQL_ROOT_USER} -p${SQL_ROOT_PWD} ping && mariadb -hmariadb -u${SQL_ROOT_USER} -p${SQL_ROOT_PWD} -e "SHOW DATABASES;" | grep ${SQL_DB}; do
#	sleep 2
#done
#echo "SQL ADMIN REACHED"


php-fpm7.3 -F;

