#!/bin/bash
set -e

# Rename incoming landing page file → index.html
for src in final-real.html final.html; do
  if [ -f "$src" ]; then
    echo "→ Renaming $src → index.html"
    mv "$src" index.html
    break
  fi
done

echo "→ Fixing links in index.html..."
sed -i '' 's|href="final-real\.html#|href="./#|g' index.html
sed -i '' 's|href="final-real\.html"|href="./"|g' index.html
sed -i '' 's|href="final\.html#|href="./#|g' index.html
sed -i '' 's|href="final\.html"|href="./"|g' index.html
sed -i '' 's|href="privacy-final\.html"|href="privacy.html"|g' index.html

echo "→ Fixing image paths in index.html..."
sed -i '' 's|src="assets/real-add-tools\.png"|src="screenshot/ai-weaver-add-tools-menu-small.png"|g' index.html
sed -i '' 's|src="assets/real-toolbar-capture\.png"|src="screenshot/ai-weaver-toolbar-capture-portion.png"|g' index.html
sed -i '' 's|src="assets/real-berlin-page\.png"|src="screenshot/berlin-events-page-modal.png"|g' index.html
sed -i '' 's|src="assets/real-toolbar-models\.png"|src="screenshot/ai-weaver-toolbar-model-selector.png"|g' index.html
sed -i '' 's|src="assets/real-gemini-events\.png"|src="screenshot/ai-weaver-gemini-event-recommendations.png"|g' index.html

echo "→ Staging and pushing..."
git add -A
git commit -m "deploy: update index.html ($(date '+%Y-%m-%d %H:%M'))"
git -c http.postBuffer=524288000 \
    -c credential.helper='!f() { echo "username=rrthurein"; echo "password=$(gh auth token)"; }; f' \
    push origin main

echo "✓ Done — https://rrthurein.github.io/tasuku/"
