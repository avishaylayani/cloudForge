#!/usr/bin/env bash
#########################################################################
# Created by Ori Nahum and Avishay Layani
# Purpose: Runs Terraform deployment in AWS
# Version: 3.2.2
# Date: 15/12/2024
# set -x          # Enable debug mode
set -o errexit  # Exit on any command failing 
set -o pipefail # Return non-zero status if any part of a pipeline fails
#########################################################################

terraform_operations() {
    echo -e "$(colorize 'Running Terraform operations...' 'magenta')" && sleep 0.6

    # Initialize and apply Terraform for the bucket
    cd terraform/bucket || exit
    terraform plan > ../plans/terraform_bucket_plan_output.txt 2>&1
    echo -e "$(colorize 'Terrafrom for the bucket Plan Include errors in the human-readable created...' 'yellow')" && sleep 0.6
    terraform init && terraform apply --auto-approve
    cd - > /dev/null

    # Initialize and apply Terraform for the main structure
    cd terraform/main_structure || exit
    terraform plan > ../plans/main_structure_plan_output.txt 2>&1
    echo -e "$(colorize 'Terrafrom for the main structure Plan Include errors in the human-readable created...' 'yellow')" && sleep 0.6
    terraform init && terraform apply --auto-approve
    cd - > /dev/null
}

terraform_destroy() {
    echo -e "$(colorize 'Destroying Terraform resources...' 'red')" && sleep 0.6

    # Destroy Terraform resources for the main structure
    cd terraform/main_structure || exit
    terraform destroy --auto-approve
    cd - > /dev/null

    # Clean up S3 bucket contents before destruction
    cd terraform/bucket || exit

    # Retrieve the bucket name from Terraform outputs
    BUCKET_NAME=$(terraform output -raw bucket_name)

    if [[ -n "$BUCKET_NAME" ]]; then
        echo -e "$(colorize "Cleaning up S3 bucket: $BUCKET_NAME" 'yellow')" && sleep 0.6

        # Delete all objects and object versions from the bucket
        aws s3api delete-objects --bucket "$BUCKET_NAME" --delete \
            "$(aws s3api list-object-versions --bucket "$BUCKET_NAME" \
            --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' | jq -c '{Objects: .Objects, Quiet: false}')" \
            || echo -e "$(colorize 'Failed to delete objects from the bucket. Continuing with destroy.' 'red')" && sleep 0.6
    else
        echo -e "$(colorize 'Bucket name is empty. Skipping bucket cleanup.' 'red')" && sleep 0.6
    fi

    # Destroy Terraform resources for the bucket
    terraform destroy --auto-approve
    cd - > /dev/null
}