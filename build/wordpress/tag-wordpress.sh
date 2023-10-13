# tag all the drupal images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker tag wordpress:base-$VARIANT_TAG blackflysolutions/wordpress:base-$VARIANT_TAG
done <variants.txt
