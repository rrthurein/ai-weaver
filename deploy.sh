#!/bin/bash
set -e

echo "→ Fixing links..."

# final.html / final-real.html → ./ (but not privacy-final.html, handle that separately)
for f in *.html; do
  sed -i '' 's|href="final-real\.html#|href="./#|g' "$f"
  sed -i '' 's|href="final-real\.html"|href="./"|g' "$f"
  sed -i '' 's|href="final\.html#|href="./#|g' "$f"
  sed -i '' 's|href="final\.html"|href="./"|g' "$f"
done

# privacy-final.html → privacy.html
for f in *.html; do
  sed -i '' 's|href="privacy-final\.html"|href="privacy.html"|g' "$f"
done

echo "→ Fixing image paths..."

declare -A IMG_MAP=(
  ["assets/real-add-tools.png"]="screenshot/ai-weaver-add-tools-menu-small.png"
  ["assets/real-toolbar-capture.png"]="screenshot/ai-weaver-toolbar-capture-portion.png"
  ["assets/real-berlin-page.png"]="screenshot/berlin-events-page-modal.png"
  ["assets/real-toolbar-models.png"]="screenshot/ai-weaver-toolbar-model-selector.png"
  ["assets/real-gemini-events.png"]="screenshot/ai-weaver-gemini-event-recommendations.png"
)

for f in *.html; do
  for key in "${!IMG_MAP[@]}"; do
    val="${IMG_MAP[$key]}"
    sed -i '' "s|src=\"${key}\"|src=\"${val}\"|g" "$f"
  done
done

echo "→ Staging and pushing..."

git add -A
git commit -m "deploy: fix links and image paths ($(date '+%Y-%m-%d %H:%M'))"
git -c http.postBuffer=524288000 \
    -c credential.helper='!f() { echo "username=rrthurein"; echo "password=$(gh auth token)"; }; f' \
    push origin main

echo "✓ Done — https://rrthurein.github.io/ai-weaver/"
