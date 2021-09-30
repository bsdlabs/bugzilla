#!/bin/sh
set -e

# Bugzilla configuration
cat > /usr/local/etc/apache24/Includes/bugzilla.conf << EOF

<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot "/usr/local/www"
  ServerName localhost
  AddHandler cgi-script .cgi
  <Directory "/usr/local/www">
    DirectoryIndex index.cgi
    Options Indexes FollowSymLinks ExecCGI
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
EOF

# Bugzilla modules
cat > /usr/local/etc/apache24/modules.d/010_bugzilla.conf << EOF
LoadModule cgi_module libexec/apache24/mod_cgi.so
LoadModule expires_module libexec/apache24/mod_expires.so
EOF

# Start Apache
service apache24 onestart
