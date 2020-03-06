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
    # for simplicity we only have one domain
    export DOMAINS="$(get_var "application_host")"
    export GOOGLE_APPLICATION_CREDENTIALS="/usr/local/gs-account/account.json"
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

create_domain_txt_file(){
    mkdir /usr/local/domains
    echo "${DOMAINS}" > /usr/local/domains/domain_list.txt
}

create_certificates(){
    certbot='/usr/bin/certbot  --agree-tos --email ndunguwanyinge@gmail.com --nginx --redirect --expand -n '
    vhost=( `cat "/usr/local/domains/domain_list.txt" `)

    # loop variables
    ssl_exec="${certbot}"
    n=1

    #################### START ##########################

    for t in "${vhost[@]}"
    do

        ssl_exec="${ssl_exec} -d $t "
        let "n++"

        # every 100th domain, create a SSL certificate
        if (( n == 100 )); then

            $ssl_exec
            #echo $ssl_exec

        # reset the loop variables
        ssl_exec="${certbot}"
        n=1
    fi

    done

    # create SSl certificate for the rest of the domains
    #echo $ssl_exec
    $ssl_exec
}

setup_ssl_certificates(){
    sudo cp -r /etc/letsencrypt/ ~/
    sudo chmod -R 777 ~/letsencrypt
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
    create_domain_txt_file
    create_certificates
    setup_ssl_certificates
    clone_repository
    create_service_account
    copy_nginx_conf
    copy_supervisord_conf
    configure_pelly_website
}

main
