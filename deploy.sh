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

for f in *.html; do
  sed -i '' 's|src="assets/real-add-tools\.png"|src="screenshot/ai-weaver-add-tools-menu-small.png"|g' "$f"
  sed -i '' 's|src="assets/real-toolbar-capture\.png"|src="screenshot/ai-weaver-toolbar-capture-portion.png"|g' "$f"
  sed -i '' 's|src="assets/real-berlin-page\.png"|src="screenshot/berlin-events-page-modal.png"|g' "$f"
  sed -i '' 's|src="assets/real-toolbar-models\.png"|src="screenshot/ai-weaver-toolbar-model-selector.png"|g' "$f"
  sed -i '' 's|src="assets/real-gemini-events\.png"|src="screenshot/ai-weaver-gemini-event-recommendations.png"|g' "$f"
done

echo "→ Staging and pushing..."

git add -A
git commit -m "deploy: fix links and image paths ($(date '+%Y-%m-%d %H:%M'))"
git -c http.postBuffer=524288000 \
    -c credential.helper='!f() { echo "username=rrthurein"; echo "password=$(gh auth token)"; }; f' \
    push origin main

echo "✓ Done — https://rrthurein.github.io/ai-weaver/"
