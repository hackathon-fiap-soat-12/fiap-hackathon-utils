#!/bin/bash

set -e

BASE_DIR="$(realpath "$(dirname "$0")")"

run_terraform() {
    local folder_path=$1
    local abs_folder="$BASE_DIR/$folder_path"

    echo "Entering Terraform folder: $abs_folder"

    # Erase previous Terraform state files and working directory
    echo "Erasing previous Terraform state files and directories..."
    rm -f "$abs_folder/terraform.tfstate" "$abs_folder/terraform.tfstate.backup" "$abs_folder/.terraform.lock.hcl" 
    rm -rf "$abs_folder/.terraform"

    # Reset the configuration by reinitializing Terraform
    echo "Resetting configuration with 'terraform init -reconfigure'..."
    terraform -chdir="$abs_folder" init -reconfigure || {
        echo "Terraform init failed in $abs_folder"
        exit 1
    }

    echo ""
    echo "############################################"
    echo "######### FINISHED TERRAFORM CLEAN #########"
    echo "############################################"
    echo ""
}

run_terraform "fiap-hackathon-vpc/terraform"
run_terraform "fiap-hackathon-db/terraform"
run_terraform "fiap-hackathon-queue/terraform"
run_terraform "fiap-hackathon-k8s-cluster/terraform"
run_terraform "fiap-hackathon-k8s-infra/terraform"
run_terraform "fiap-hackathon-observability/terraform"
run_terraform "fiap-hackathon-lambda-video-receive/terraform"
run_terraform "fiap-hackathon-lambda-authorizer/terraform"
run_terraform "fiap-hackathon-api-gateway/terraform"
run_terraform "fiap-hackathon-cognito/terraform"
run_terraform "fiap-hackathon-process/terraform"
run_terraform "fiap-hackathon-mail/terraform"
run_terraform "fiap-hackathon-video/terraform"
# run_terraform "payment/terraform"

echo "All terraform apply commands have completed."
