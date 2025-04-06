#!/bin/bash

set -e

BASE_DIR="$(realpath "$(dirname "$0")")"

source ./env_variables.sh


run_terraform() {
    local folder_path=$1
    local abs_folder="$BASE_DIR/$folder_path"

    echo "Running terraform apply in $abs_folder"

    terraform -chdir="$abs_folder" apply --auto-approve || {
        echo "Terraform apply failed in $abs_folder"
        exit 1
    }

    echo ""
    echo ""
    echo "Terraform apply completed in $abs_folder"
    echo "############################################"
    echo "######### FINISHED TERRAFORM APPLY #########"
    echo "############################################"
    echo ""
    echo ""
}

run_terraform "fiap-hackathon-vpc/terraform"
run_terraform "fiap-hackathon-db/terraform"
run_terraform "fiap-hackathon-queue/terraform"
run_terraform "fiap-hackathon-k8s-cluster/terraform"
run_terraform "fiap-hackathon-k8s-infra/terraform"
run_terraform "fiap-hackathon-observability/terraform"
#run_terraform "fiap-hackathon-lambda-video-receive/terraform"
# run_terraform "fiap-hackathon-lambda-auth/terraform"
# run_terraform "fiap-hackathon-cognito/terraform"
# run_terraform "fiap-hackathon-api-gateway/terraform"
# run_terraform "fiap-hackathon-process/terraform"
# run_terraform "fiap-hackathon-mail/terraform"
# run_terraform "fiap-hackathon-video/terraform"
# run_terraform "payment/terraform"

echo "All terraform apply commands have completed."











