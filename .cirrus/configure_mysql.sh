#!/bin/sh

# Set the following values, which increase the maximum attachment size and make
# it possible to search for short words and terms:
sed -i '' '/max_allowed_packet/s/.*/max_allowed_packet              = 100M/' /usr/local/etc/mysql/my.cnf
sed -i '' -e 's/\[mysqld\]/[mysqld]\nft_min_word_len                 = 2/' /usr/local/etc/mysql/my.cnf

# Start MySQL
service mysql-server onestart

# Add a user to MySQL for Bugzilla to use
# NB: $db_pass is an encrypted variable.
#     https://cirrus-ci.org/guide/writing-tasks/#encrypted-variables
mysql_secret="$(tail -1 /root/.mysql_secret)"
mysql --connect-expired-password -u root -p${mysql_secret} << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysql_secret';
GRANT ALL PRIVILEGES ON bugs.* TO 'bugs'@'localhost' IDENTIFIED BY '$db_pass';
FLUSH PRIVILEGES;
EOF

# Restart MySQL
service mysql-server onerestart
