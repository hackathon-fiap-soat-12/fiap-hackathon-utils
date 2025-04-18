#!/bin/bash

set -e

BASE_DIR="$(realpath "$(dirname "$0")")"

source ./env_variables.sh


run_terraform() {
    local folder_path=$1
    local abs_folder="$BASE_DIR/$folder_path"

    echo "Running terraform destroy in $abs_folder"

    terraform -chdir="$abs_folder" destroy --auto-approve || {
        echo "Terraform destroy failed in $abs_folder"
        exit 1
    }

    echo ""
    echo ""
    echo "Terraform destroy completed in $abs_folder"
    echo "############################################"
    echo "######### FINISHED TERRAFORM destroy #########"
    echo "############################################"
    echo ""
    echo ""
}

# run_terraform "payment/terraform"
run_terraform "fiap-hackathon-video/terraform"
run_terraform "fiap-hackathon-mail/terraform"
run_terraform "fiap-hackathon-process/terraform"
run_terraform "fiap-hackathon-cognito/terraform"
run_terraform "fiap-hackathon-api-gateway/terraform"
run_terraform "fiap-hackathon-lambda-authorizer/terraform"
run_terraform "fiap-hackathon-lambda-video-receive/terraform"
run_terraform "fiap-hackathon-observability/terraform"
run_terraform "fiap-hackathon-k8s-infra/terraform"
run_terraform "fiap-hackathon-k8s-cluster/terraform"
run_terraform "fiap-hackathon-queue/terraform"
run_terraform "fiap-hackathon-db/terraform"
run_terraform "fiap-hackathon-vpc/terraform"

echo "All terraform destroy commands have completed."

