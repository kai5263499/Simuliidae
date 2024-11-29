#!/bin/bash
set -x
# build all the wordpress-civicrm images that I need.
# includes the 'base' images that do NOT include the wordpress code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
REPOSITORY_FROM=${REPOSITORY_FROM:-''}
PLATFORM=${PLATFORM:-linux/amd64}
REPOSITORY_ADDRESS=${REPOSITORY_ADDRESS:-''}

# Check if variants-override.txt exists and use it if it does, otherwise use variants.txt
VARIANTS_FILE="variants.txt"
if [ -f "variants-override.txt" ]; then
  VARIANTS_FILE="variants-override.txt"
fi

while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/^latest\///' -e 's/\//-/g')
  IMAGE_TAG_PREFIX="${REPOSITORY_ADDRESS:+$REPOSITORY_ADDRESS/}simuliidae-wordpress"
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-base -t $IMAGE_TAG_PREFIX:vhttp-base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-base -t $IMAGE_TAG_PREFIX:admin-base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-build-crm -t $IMAGE_TAG_PREFIX:admin-build-crm-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-cms -t $IMAGE_TAG_PREFIX:vhttp-cms-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-cms -t $IMAGE_TAG_PREFIX:admin-cms-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-crm -t $IMAGE_TAG_PREFIX:vhttp-crm-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --platform $PLATFORM --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-crm -t $IMAGE_TAG_PREFIX:admin-crm-$VARIANT_TAG $VARIANT_DIR
done <"$VARIANTS_FILE"