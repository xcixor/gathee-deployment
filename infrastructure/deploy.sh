#!/usr/bin/env bash

set -o errexit
set -o pipefail
# set -o xtrace

get_var(){
    local name="$1"
    curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${name}"
}

get_required_variables () {
    export IP_ADDRESS="$(get_var "ip_address")"
    ENVIRONMENT="$(get_var "django_environment")"
    export DJANGO_SETTINGS_MODULE=core.settings.${ENVIRONMENT}
    export SECRET_KEY="$(sudo openssl rand -hex 64)"
    export DATABASE_NAME="$(get_var "database_name")"
    export DATABASE_USER="$(get_var "database_user")"
    export DATABASE_PASSWORD="$(get_var "database_password")"
    export POSTGRES_IP="$(get_var "postgres_ip")"
    export GS_BUCKET_NAME="$(get_var "gs_bucket")"
    export GS_BUCKET_URL="$(get_var "gs_bucket_url")"
    export APPLICATION_HOST="$(get_var "application_host")"
    export GITHUB_BRANCH="$(get_var "github_branch")"
    export NGINX_SERVER_NAME="${APPLICATION_HOST}"
    export TWILIO_ACCOUNT_SID="$(get_var "twilio_account_sid")"
    export TWILIO_AUTH_TOKEN="$(get_var "twilio_auth_token")"
    export EMAIL_HOST="$(get_var "email_host")"
    export EMAIL_HOST_USER="$(get_var "email_host_user")"
    export EMAIL_HOST_PASSWORD="$(get_var "email_host_password")"
    export SERVICE_ACCOUNT="$(get_var "gs_credentials")"
    export GOOGLE_APPLICATION_CREDENTIALS="/usr/local/gs-account/account.json"
    # export GOOGLE_APPLICATION_CREDENTIALS=$(cat /etc/account.json)
}

clone_repository() {
    cd ~
    if [ "${GITHUB_BRANCH}" ]; then
        git clone -b "${GITHUB_BRANCH}" https://github.com/xcixor/gathee.git
    else
        git clone https://github.com/xcixor/gathee.git
    fi
    cd gathee
}

create_service_account(){
    mkdir /usr/local/gs-account
    echo "${SERVICE_ACCOUNT}" > /usr/local/gs-account/account.json
}

copy_nginx_conf() {
    envsubst '\$NGINX_SERVER_NAME' < ~/gathee/devops/nginx.conf > /etc/nginx/conf.d/nginx.conf
}

copy_supervisord_conf () {
    sudo cp ~/gathee/devops/supervisord.conf /etc/supervisor/supervisord.conf
    sudo cp ~/gathee/devops/start.sh /usr/local/bin/start-app
    sudo chmod +x /usr/local/bin/start-app
}

configure_pelly_website() {
    pipenv lock -r >requirements.txt
    pip3 install -r requirements.txt
    python3 ~/gathee/src/core/manage.py makemigrations
    python3 ~/gathee/src/core/manage.py migrate
    python3 ~/gathee/src/core/manage.py collectstatic --no-input
    sudo systemctl restart supervisor
    sudo nginx -s reload
}


main (){
    get_required_variables
    clone_repository
    create_service_account
    copy_nginx_conf
    copy_supervisord_conf
    configure_pelly_website
}

main