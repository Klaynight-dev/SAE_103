#!/usr/bin/bash

container_id=$(docker run --rm -d dpokidov/imagemagick)
input_dir="./"
output_dir="./"

mkdir -p "$output_dir"

for img in "$input_dir"/*; do
   if [[ $(file --mime-type -b "$img") != image/webp ]]; then
      docker exec "$container_id" magick "$img" -resize "960x600>" -resize "x600<" -resize "320x200>" -resize "x200<" -quality 80 "$output_dir/$(basename "${img%.*}.webp")"
   fi
done

docker stop "$container_id"
