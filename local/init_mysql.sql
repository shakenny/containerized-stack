GRANT ALL PRIVILEGES ON *.* TO 'kennyyang'@'%';
USE mysql;
ALTER USER 'kennyyang'@'%' IDENTIFIED WITH mysql_native_password BY '!Ybw324!';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '!Ybw324!' PASSWORD EXPIRE NEVER;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '!Ybw324!' PASSWORD EXPIRE NEVER;
FLUSH PRIVILEGES;
