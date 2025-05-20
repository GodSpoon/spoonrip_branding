#!/bin/bash

# --- Configuration ---
# Directory where the new SVG files will be created
OUTPUT_DIR="/home/sam/SPOON_GIT/spoonrip_branding/smudge-colors/colors"
# Path to the reference SVG file
REFERENCE_SVG_PATH="/home/sam/SPOON_GIT/spoonrip_branding/smudge-colors/src/smudge.svg"
# Path to the CSV file containing color names and hex values
COLOR_CSV_PATH="/home/sam/SPOON_GIT/spoonrip_branding/smudge-colors/src/colornames.csv"

# Check if the reference SVG file exists
if [ ! -f "$REFERENCE_SVG_PATH" ]; then
    echo "Error: Reference SVG file not found at $REFERENCE_SVG_PATH"
    exit 1
fi

# Check if the color CSV file exists
if [ ! -f "$COLOR_CSV_PATH" ]; then
    echo "Error: Color CSV file not found at $COLOR_CSV_PATH"
    exit 1
fi

# Read the content of the reference SVG file into a variable
REFERENCE_SVG_CONTENT=$(cat "$REFERENCE_SVG_PATH")

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Starting SVG generation..."
echo "Reading reference SVG from: $REFERENCE_SVG_PATH"
echo "Reading color data from: $COLOR_CSV_PATH"

# Read the CSV file line by line, skipping the header
tail -n +2 "$COLOR_CSV_PATH" | while IFS=',' read -r color_name hex_value source_info; do # Assuming CSV format: name,hex,source (source_info might be empty or have extra data)
    # Trim leading/trailing whitespace from hex_value and color_name
    hex_value=$(echo "$hex_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    color_name=$(echo "$color_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Ensure hex_value starts with #, add if missing (and is a valid hex)
    if [[ "$hex_value" =~ ^[0-9a-fA-F]{3,6}$ ]]; then
        hex_value="#${hex_value}"
    elif [[ ! "$hex_value" =~ ^#[0-9a-fA-F]{3,6}$ ]]; then
        echo "Skipping invalid hex value: $hex_value for color $color_name"
        continue
    fi

    # Sanitize color_name for filename (replace spaces/special chars with underscores)
    sanitized_color_name=$(echo "$color_name" | sed -E 's/[^a-zA-Z0-9_.-]+/_/g')

    # Remove '#' from hex_value for the filename
    hex_for_filename="${hex_value#\#}"

    # Construct the output SVG filename: $hex-$colorname.svg
    # The source of the color (e.g., js_basename) is no longer directly available from the CSV in the same way
    # We can use a generic identifier or modify if source is part of CSV
    output_svg_filename="${hex_for_filename}-${sanitized_color_name}.svg"
    output_svg_path="${OUTPUT_DIR}/${output_svg_filename}"

    # Replace the fill color in the reference SVG and save the new SVG
    echo "$REFERENCE_SVG_CONTENT" | sed "s|fill=\"#121212\"|fill=\"${hex_value}\"|g" >"$output_svg_path"

    echo "  Generated: $output_svg_filename"
done

echo "All SVG files generated in $OUTPUT_DIR."
