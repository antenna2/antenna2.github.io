#!/bin/bash

# Generates sitemap.xml from the current directory (assumed to be web root)

domain="https://antenna2.github.io"
sitemap_file="sitemap.xml"

# Create or overwrite the sitemap.xml file
echo '<?xml version="1.0" encoding="UTF-8"?>' > "$sitemap_file"
echo '<!-- sitemap-generator-url="https://github.com/antenna2/antenna2.github.io/blob/main/sitemap.sh" -->' >> "$sitemap_file"
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> "$sitemap_file"

# Find all HTML files and build entries
find . -name '*.html' | while read -r file; do
    # Get the last modification date in UTC
    modification_date=$(TZ=UTC stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$file")

    # Strip leading "./" to make clean relative path
    relative_path=${file#./}

    # Replace "index.html" with "" so URLs use folder paths
    relative_path=${relative_path//index.html/}

    # Prepend a slash if not empty
    if [ -n "$relative_path" ]; then
        relative_path="/$relative_path"
    fi

    # Write URL entry
    echo "  <url>" >> "$sitemap_file"
    echo "    <loc>$domain$relative_path</loc>" >> "$sitemap_file"
    echo "    <lastmod>$modification_date</lastmod>" >> "$sitemap_file"
    echo "  </url>" >> "$sitemap_file"
done

# Close XML
echo '</urlset>' >> "$sitemap_file"

echo "Sitemap generated successfully at $sitemap_file"
