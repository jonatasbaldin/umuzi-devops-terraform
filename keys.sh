#!/bin/bash

# Check if the file exists
if [ -e "names.txt" ]; then
    mkdir -p keys

    # Read each line from the file and echo it
    while IFS= read -r name; do
        if [ -e "keys/$name.pem" ]; then
            echo "key $name already exists"
            continue
        fi

        echo "creating ssh key for: $name"

        aws ec2 create-key-pair --key-name $name --query 'KeyMaterial' --output text --region af-south-1 > keys/$name.pem
    done < "names.txt"
fi