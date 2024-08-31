# Add missing indices to the database.
docker exec --user www-data nextcloud /var/www/html/occ db:add-missing-indices

# Perform mimetype migrations for Nextcloud.
docker exec --user www-data nextcloud /var/www/html/occ maintenance:repair --include-expensive

# Set mode for background jobs to 'cron'.
docker exec --user www-data nextcloud /var/www/html/occ background:cron

# Add crontab to run background jobs every five minutes.
(crontab -l; echo "*/5  *  *  *  * docker exec -u www-data nextcloud php /var/www/html/cron.php")|awk '!x[$0]++'|crontab -

# Run background jobs between 01:00am UTC and 05:00am UTC.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set maintenance_window_start --type=integer --value=1

# Set default language to German.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set default_language --type=string --value='de'

# Set default locale to Germany.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set default_locale --type=string --value='de_DE'

# Set the default phone region to Germany.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set default_phone_region --type=string --value='DE'

# Set the default time zone to Europe/Berlin.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set default_timezone --type=string --value='Europe/Berlin'

# Create default directory structure for new users.
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Desktop
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Documents
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Downloads
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Music
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Pictures
docker exec --user www-data nextcloud mkdir -p /var/www/html/core/custom_skeleton/Videos

# Set default directory structure for new users.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set skeletondirectory --type=string --value='/var/www/html/core/custom_skeleton'

# Disable template directory for new users.
docker exec --user www-data nextcloud /var/www/html/occ config:system:set templatedirectory --type=string --value=''

# Update all Nextcloud apps.
docker exec --user www-data nextcloud /var/www/html/occ app:update --all

# Download and install Nextcloud apps.
docker exec --user www-data nextcloud /var/www/html/occ app:install calendar
docker exec --user www-data nextcloud /var/www/html/occ app:install circles
docker exec --user www-data nextcloud /var/www/html/occ app:install cloud_federation_api
docker exec --user www-data nextcloud /var/www/html/occ app:install contactsinteraction
docker exec --user www-data nextcloud /var/www/html/occ app:install dav
docker exec --user www-data nextcloud /var/www/html/occ app:install federatedfilesharing
docker exec --user www-data nextcloud /var/www/html/occ app:install federation
docker exec --user www-data nextcloud /var/www/html/occ app:install files
docker exec --user www-data nextcloud /var/www/html/occ app:install files_downloadlimit
docker exec --user www-data nextcloud /var/www/html/occ app:install files_pdfviewer
docker exec --user www-data nextcloud /var/www/html/occ app:install files_reminders
docker exec --user www-data nextcloud /var/www/html/occ app:install files_sharing
docker exec --user www-data nextcloud /var/www/html/occ app:install files_trashbin
docker exec --user www-data nextcloud /var/www/html/occ app:install files_versions
docker exec --user www-data nextcloud /var/www/html/occ app:install logreader
docker exec --user www-data nextcloud /var/www/html/occ app:install lookup_server_connector
docker exec --user www-data nextcloud /var/www/html/occ app:install oauth2
docker exec --user www-data nextcloud /var/www/html/occ app:install password_policy
docker exec --user www-data nextcloud /var/www/html/occ app:install privacy
docker exec --user www-data nextcloud /var/www/html/occ app:install provisioning_api
docker exec --user www-data nextcloud /var/www/html/occ app:install related_resources
docker exec --user www-data nextcloud /var/www/html/occ app:install serverinfo
docker exec --user www-data nextcloud /var/www/html/occ app:install settings
docker exec --user www-data nextcloud /var/www/html/occ app:install sharebymail
docker exec --user www-data nextcloud /var/www/html/occ app:install systemtags
docker exec --user www-data nextcloud /var/www/html/occ app:install text
docker exec --user www-data nextcloud /var/www/html/occ app:install theming
docker exec --user www-data nextcloud /var/www/html/occ app:install twofactor_backupcodes
docker exec --user www-data nextcloud /var/www/html/occ app:install updatenotification
docker exec --user www-data nextcloud /var/www/html/occ app:install viewer
docker exec --user www-data nextcloud /var/www/html/occ app:install workflowengine

# Disable redundant Nextcloud apps.
docker exec --user www-data nextcloud /var/www/html/occ app:disable activity
docker exec --user www-data nextcloud /var/www/html/occ app:disable admin_audit
docker exec --user www-data nextcloud /var/www/html/occ app:disable bruteforcesettings
docker exec --user www-data nextcloud /var/www/html/occ app:disable comments
docker exec --user www-data nextcloud /var/www/html/occ app:disable dashboard
docker exec --user www-data nextcloud /var/www/html/occ app:disable encryption
docker exec --user www-data nextcloud /var/www/html/occ app:disable files_external
docker exec --user www-data nextcloud /var/www/html/occ app:disable firstrunwizard
docker exec --user www-data nextcloud /var/www/html/occ app:disable nextcloud_announcements
docker exec --user www-data nextcloud /var/www/html/occ app:disable notifications
docker exec --user www-data nextcloud /var/www/html/occ app:disable photos
docker exec --user www-data nextcloud /var/www/html/occ app:disable recommendations
docker exec --user www-data nextcloud /var/www/html/occ app:disable support
docker exec --user www-data nextcloud /var/www/html/occ app:disable survey_client
docker exec --user www-data nextcloud /var/www/html/occ app:disable suspicious_login
docker exec --user www-data nextcloud /var/www/html/occ app:disable twofactor_totp
docker exec --user www-data nextcloud /var/www/html/occ app:disable user_ldap
docker exec --user www-data nextcloud /var/www/html/occ app:disable user_status
docker exec --user www-data nextcloud /var/www/html/occ app:disable weather_status
