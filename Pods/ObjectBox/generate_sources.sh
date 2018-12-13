#!/bin/bash

set -e

sourcery="$PODS_ROOT/Sourcery/bin/sourcery"

SOURCERY_SETTINGS_PATH="$PROJECT_DIR/sourcery.$1.yml"

echo -e "project:\n  file: `basename \"${PROJECT_FILE_PATH}\"`" > $SOURCERY_SETTINGS_PATH
echo -e "  target:\n    name: \"$1\"" >> $SOURCERY_SETTINGS_PATH
echo -e "    module: \"${PRODUCT_MODULE_NAME}\"" >> $SOURCERY_SETTINGS_PATH
echo -e "templates:\n  - Pods/ObjectBox/templates" >> $SOURCERY_SETTINGS_PATH
echo -e "output:\n   path: ./generated/" >> $SOURCERY_SETTINGS_PATH

if [ -f "$sourcery" ]; then
  "$sourcery" --config $SOURCERY_SETTINGS_PATH
else
  echo "error: Cannot find Sourcery in the expected location at '$sourcery'"
  exit 1
fi

rm $SOURCERY_SETTINGS_PATH

