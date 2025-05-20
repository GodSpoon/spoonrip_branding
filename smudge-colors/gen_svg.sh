#!/bin/bash

# --- Configuration ---
# Directory containing your JavaScript color dictionary files
DICTIONARY_DIR="/home/sam/SPOON_GIT/spoonrip_branding/smudge-colors/dictionary"
# Directory where the new SVG files will be created
OUTPUT_DIR="/home/sam/SPOON_GIT/spoonrip_branding/smudge-colors/colors"
# Path to the reference SVG file
REFERENCE_SVG_PATH="${DICTIONARY_DIR}/smudge.svg"

# Check if the reference SVG file exists
if [ ! -f "$REFERENCE_SVG_PATH" ]; then
    echo "Error: Reference SVG file not found at $REFERENCE_SVG_PATH"
    exit 1
fi

# Read the content of the reference SVG file into a variable
REFERENCE_SVG_CONTENT=$(cat "$REFERENCE_SVG_PATH")

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Starting SVG generation..."
echo "Reading reference SVG from: $REFERENCE_SVG_PATH"

# Loop through each JavaScript file in the dictionary directory
for js_file in "$DICTIONARY_DIR"/*.js; do
    # Check if any JS files exist
    if [ ! -f "$js_file" ]; then
        echo "No JavaScript color dictionary files found in $DICTIONARY_DIR. Skipping."
        continue
    fi

    # Extract the base name of the JavaScript file (e.g., "x11", "roygbiv")
    js_filename=$(basename -- "$js_file")
    js_basename="${js_filename%.*}" # Remove .js extension

    echo "Processing $js_filename..."

    # Read the content of the JavaScript file and extract color data
    # This uses grep to find lines with 'name:' and 'hex:', then sed to extract the values.
    # The output format is "color_name|hex_value" for easy parsing in the while loop.
    grep -oE "name: '[^']+',[[:space:]]*hex: '#[0-9a-fA-F]+'" "$js_file" |
        sed -E "s/name: '([^']+)',[[:space:]]*hex: '([^']+)'/\1|\2/" |
        while IFS='|' read -r color_name hex_value; do
            # Sanitize color_name for filename (replace spaces/special chars with underscores)
            sanitized_color_name=$(echo "$color_name" | sed -E 's/[^a-zA-Z0-9_.-]+/_/g')

            # Remove '#' from hex_value for the filename
            hex_for_filename="${hex_value#\#}"

            # Construct the output SVG filename in the new format: $hex-$colorname-$jsfile.svg
            output_svg_filename="${hex_for_filename}-${sanitized_color_name}-${js_basename}.svg"
            output_svg_path="${OUTPUT_DIR}/${output_svg_filename}"

            # Replace the fill color in the reference SVG and save the new SVG
            # We use sed to replace the specific background path fill attribute.
            # The 's|fill="#[^"]*"|fill="'"$hex_value"'"|g' part searches for 'fill="#' followed by any characters
            # until the next '"', and replaces the whole match with 'fill="<new_hex_value>"'.
            echo "$REFERENCE_SVG_CONTENT" | sed 's|fill="#121212"|fill="'"$hex_value"'"|g' >"$output_svg_path"

            echo "  Generated: $output_svg_filename"
        done
    echo "Finished processing $js_filename."
    echo ""
done

echo "All SVG files generated in $OUTPUT_DIR."
