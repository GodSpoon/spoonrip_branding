# Smudge Colors SVG Generator

This project generates a series of SVG files, each representing a color from a predefined list. The SVGs are based on a template (`src/smudge.svg`) where the background color is dynamically replaced.

## How to Use

1.  **Prepare your color data**:
    *   Ensure you have a CSV file named `colornames.csv` inside the `src/` directory.
    *   The CSV file must have a header row (e.g., `Name,Hex`).
    *   Subsequent rows should contain the color name in the first column and the hex value in the second column (e.g., `AliceBlue,#F0F8FF`).
        Example `src/colornames.csv`:
        ```csv
        Name,Hex,Source
        AliceBlue,#F0F8FF,X11
        AntiqueWhite,#FAEBD7,X11
        Red,#FF0000,Basic
        Green,#00FF00,Basic
        ```
        *Note: The script primarily uses the first two columns (Name, Hex). Additional columns like 'Source' will be ignored by the SVG generation logic but can be present in your CSV.*

2.  **Reference SVG**:
    *   Place your reference SVG template as `smudge.svg` in the `src/` directory.
    *   The script is configured to replace the fill color `fill="#121212"` in this reference SVG. Ensure your `src/smudge.svg` has an element with this exact fill attribute that you intend to change.

3.  **Run the script**:
    *   Navigate to the `smudge-colors` directory in your terminal.
    *   Make the script executable (if you haven't already): `chmod +x gen_svg.sh`
    *   Execute the `gen_svg.sh` script:
        ```bash
        ./gen_svg.sh
        ```
    *   The generated SVG files will be placed in the `colors/` directory. Each file will be named in the format `HEXVALUE-ColorName.svg` (e.g., `F0F8FF-AliceBlue.svg`).

## Using Generated SVGs in Markdown

You can embed these generated SVGs directly into your Markdown documents to display colors. This is useful for documentation, style guides, or any place you want to visually represent a color palette.

**General Syntax:**

To display the color smudge:
```markdown
![Color Name](./colors/HEXVALUE-ColorName.svg)
```

To display it with its name and hex code:
```markdown
Color Name (`#HEXVALUE`): ![HEXVALUE-ColorName.svg](./colors/HEXVALUE-ColorName.svg)
```

**Examples:**

Assuming your Markdown file is in the `smudge-colors` directory or a parent directory, and you are referencing SVGs from the `smudge-colors/colors/` directory:

1.  **Displaying "Alice Blue"**:
    If `AliceBlue` with hex `#F0F8FF` was processed, an SVG named `F0F8FF-AliceBlue.svg` would be generated.

    ```markdown
    Alice Blue (`#F0F8FF`): ![F0F8FF-AliceBlue.svg](./colors/F0F8FF-AliceBlue.svg)
    ```
    (If your markdown file is in the root of `spoonrip_branding`, the path would be `./smudge-colors/colors/F0F8FF-AliceBlue.svg`)

2.  **Displaying "Red"**:
    If `Red` with hex `#FF0000` was processed, an SVG named `FF0000-Red.svg` would be generated.

    ```markdown
    Red (`#FF0000`): ![FF0000-Red.svg](./colors/FF0000-Red.svg)
    ```

3.  **Creating a Color Palette Table**:

    | Name         | Hex     | Preview                                       |
    |--------------|---------|-----------------------------------------------|
    | Alice Blue   | #F0F8FF | ![F0F8FF-AliceBlue.svg](./colors/F0F8FF-AliceBlue.svg) |
    | Red          | #FF0000 | ![FF0000-Red.svg](./colors/FF0000-Red.svg)       |
    | Forest Green | #228B22 | ![228B22-ForestGreen.svg](./colors/228B22-ForestGreen.svg) |

**Important Considerations for Paths:**

*   The path to the SVG in your Markdown (e.g., `./colors/HEXVALUE-ColorName.svg`) is **relative to the location of the Markdown file itself**. Adjust the path accordingly based on your project structure.
*   For web-based Markdown renderers (like GitHub, GitLab, etc.), ensure the `colors` directory and its contents are committed to your repository and accessible via a relative or absolute URL path. If you are hosting this as part of a website, the path might look like `/path-to-repo/smudge-colors/colors/HEXVALUE-ColorName.svg`.

This method allows for a dynamic and visually appealing way to reference specific colors directly within your documentation.