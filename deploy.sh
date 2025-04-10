#!/bin/bash

# Set the base directory to the script's location
BASE_DIR="$(realpath "$(dirname "$0")")"

# Source environment variables (assuming this file exists in your setup)
source ./env_variables.sh

# Function to run Terraform apply in a given folder
run_terraform() {
    local folder_path=$1
    local abs_folder="$BASE_DIR/$folder_path"

    echo "Starting terraform apply in $abs_folder"
    if terraform -chdir="$abs_folder" apply --auto-approve; then
        echo "Terraform apply completed successfully in $abs_folder"
        echo "############################################"
        echo "######### FINISHED TERRAFORM APPLY #########"
        echo "############################################"
        return 0
    else
        echo "Terraform apply failed in $abs_folder"
        return 1
    fi
}

# Function to run multiple Terraform applies in parallel
run_parallel() {
    local folders=("$@")  # Capture all folder arguments into an array
    local pids=()         # Array to store process IDs
    local failed=()       # Array to store failed folders

    # Start all Terraform applies in the background
    for folder in "${folders[@]}"; do
        run_terraform "$folder" &
        pids+=($!)  # Store the PID of the background process
    done

    # Wait for each background job and check its exit status
    for i in "${!pids[@]}"; do
        wait "${pids[i]}"
        if [ $? -ne 0 ]; then
            failed+=("${folders[i]}")  # Add folder to failed list if exit status is non-zero
        fi
    done

    # Report failures and exit if any occurred
    if [ ${#failed[@]} -ne 0 ]; then
        echo "The following Terraform applies failed:"
        for folder in "${failed[@]}"; do
            echo "- $folder"
        done
        exit 1
    fi
}

# Execute the Terraform applies in the specified order

# Sequential: VPC
run_terraform "fiap-hackathon-vpc/terraform" || exit 1

# Parallel: DB and Queue
run_parallel "fiap-hackathon-db/terraform" "fiap-hackathon-queue/terraform"

# Sequential: K8s Cluster
run_terraform "fiap-hackathon-k8s-cluster/terraform" || exit 1

# Parallel: K8s Infra, Observability, Lambda Video Receive, Lambda Authorizer, Process, Mail, Video
run_parallel "fiap-hackathon-k8s-infra/terraform" \
             "fiap-hackathon-observability/terraform" \
             "fiap-hackathon-lambda-video-receive/terraform" \
             "fiap-hackathon-lambda-authorizer/terraform" \
             "fiap-hackathon-process/terraform" \
             "fiap-hackathon-mail/terraform" \
             "fiap-hackathon-video/terraform"

# Sequential: API Gateway
run_terraform "fiap-hackathon-api-gateway/terraform" || exit 1

# Sequential: Cognito
run_terraform "fiap-hackathon-cognito/terraform" || exit 1

# Success message if all steps complete
echo "All terraform apply commands have completed."