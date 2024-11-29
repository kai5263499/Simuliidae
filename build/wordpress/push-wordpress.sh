#!/bin/bash
# push all the wordpress images
REPOSITORY_ADDRESS=${REPOSITORY_ADDRESS:-blackflysolutions}

# Check if variants-override.txt exists and use it if it does, otherwise use variants.txt
VARIANTS_FILE="variants.txt"
if [ -f "variants-override.txt" ]; then
  VARIANTS_FILE="variants-override.txt"
fi

while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/^latest\///' -e 's/\//-/g')
  IMAGE_TAG_PREFIX="${REPOSITORY_ADDRESS:+$REPOSITORY_ADDRESS/}simuliidae-wordpress"

  docker push $IMAGE_TAG_PREFIX:vhttp-base-$VARIANT_TAG
done <"$VARIANTS_FILE"