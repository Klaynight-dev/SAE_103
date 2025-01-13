#!/usr/bin/env bash

# Script to convert images to WebP format using ImageMagick in Docker.

# Define input and output directories
input_dir="./images"
output_dir="./images_converties"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run the Docker container and get the container ID
container_id=$(docker run --rm -dti sae103-imagick)

# Loop through each file in the input directory
for img in "$input_dir"/*; do
    # Check if the file is a regular file and an image (not already in WebP format)
    mime_type=$(file --mime-type -b "$img")
    
    if [[ -f "$img" && "$mime_type" =~ ^image/ && "$mime_type" != "image/webp" ]]; then
        # Prepare output file path (same name, but with .webp extension)
        output_file="$output_dir/$(basename "${img%.*}.webp")"
        
        # Convert image to WebP using ImageMagick's convert command in Docker
        docker cp "$img" "$container_id:/tmp/$(basename "$img")"  # Copy image to the container
        docker exec "$container_id" convert "/tmp/$(basename "$img")" \
            -resize "960x600>" \
            -resize "x600<" \
            -resize "320x200>" \
            -resize "x200<" \
            -quality 80 \
            "/tmp/$(basename "${img%.*}.webp")"
        
        # Copy the converted file back to the output directory
        docker cp "$container_id:/tmp/$(basename "${img%.*}.webp")" "$output_file"
    fi
done

# Stop the Docker container
docker stop "$container_id" > /dev/null 2>&1

echo "Conversions terminées."
