set -m

if ! cat /var/lib/mysql/.mariadb_installed 2 > /dev/null; then
  mysql_install_db 2> /dev/null;
  touch /var/lib/mysql/.mariadb_installed;
  echo "MARIADB INTALLED";
fi

mysqld_safe &

mysqladmin ping 2> /dev/null;
while [ $? -ne 0 ]; do echo "waiting for sql to setup .."; sleep 1; mysqladmin ping 2>/dev/null; done;

echo "PING SUCCESS TO MYSQL";

#export SQL_ROOT_USER=aedouard;
#export SQL_ROOT_PWD=nelito444;
#export SQL_BASIC_USER=basic_user;
#export SQL_BASIC_PWD=bonjour1234;
#export SQL_DB=wordpress;

if ! cat /var/lib/mysql/.mariadb_configured 2> /dev/null;then
  touch /var/lib/mysql/.mariadb_configured;
  mariadb -e "CREATE USER '$SQL_ROOT_USER'@'%' IDENTIFIED BY '$SQL_ROOT_PWD'"
  mariadb -e "GRANT ALL PRIVILEGES ON * . * TO '$SQL_ROOT_USER'@'%'"
  mariadb -e "FLUSH PRIVILEGES"
  mariadb -e "CREATE DATABASE IF NOT EXISTS $SQL_DB"
  mariadb -e "CREATE USER '$SQL_BASIC_USER'@'mariadb'"
  mariadb -e "GRANT ALL PRIVILEGES ON $SQL_DB . * TO '$SQL_BASIC_USER'@'mariadb'"
  mariadb -e "FLUSH PRIVILEGES"
  mariadb -e "DELETE FROM mysql.user WHERE user=''"
  mariadb -e "DELETE FROM mysql.user WHERE user='root'"
  mariadb -e "FLUSH PRIVILEGES"
  echo "SQL CONFIG DONE";
fi

fg
