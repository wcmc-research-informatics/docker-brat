#!/bin/bash

cd /var/www/brat && /var/www/brat/install.sh <<EOD
$BRAT_USERNAME
$BRAT_PASSWORD
$BRAT_EMAIL
EOD

chown -R www-data:www-data /bratdata

# patch the user config with more users
python /var/www/brat/user_patch.py

echo "Install complete. You can log in as: $BRAT_USERNAME"

exit 0
