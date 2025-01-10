#!/bin/bash

shopt -s nullglob

txt_files=(*.txt)

if [ ${#txt_files[@]} -eq 0 ]; then
    echo "No .txt files found in the current directory."
    exit 1
fi

for inputfile in "${txt_files[@]}"; do
    outputfile="${inputfile%.txt}.html"

    echo "<html>" > "$outputfile"
    echo "<body>" >> "$outputfile"

    title=""
    while IFS= read -r line; do
        if [ -z "$title" ]; then
            title="$line"
            echo "<h1>$title</h1>" >> "$outputfile"
        elif [ -z "$line" ]; then
            echo "<br>" >> "$outputfile"
        else
            echo "<p>$line</p>" >> "$outputfile"
        fi
    done < "$inputfile"

    echo "</body>" >> "$outputfile"
    echo "</html>" >> "$outputfile"

    echo "Conversion complete. Output file: $outputfile"
done
