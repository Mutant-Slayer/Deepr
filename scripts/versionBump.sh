#!/bin/bash

INCREMENT_MODE=$1 # major, minor, and patch
RELEASE_NOTES=$2 # String files

# Read the current versionCode and versionName from the build.gradle.kts.kts file
VERSION_CODE=$(grep "versionCode " app/build.gradle.kts | awk '{print $3}' | tr -d '\r''"')
VERSION_NAME=$(grep "versionName " app/build.gradle.kts | awk '{print $3}' | tr -d '\r''"')


# Split the versionName into major, minor, and patch numbers
IFS='.' read -r -a VERSION_PARTS <<< "$VERSION_NAME"

MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

#echo "$VERSION_CODE"

# Increment the appropriate version number based on the input type
case $INCREMENT_MODE in
  "major") ((MAJOR++)); MINOR=0; PATCH=0;;
  "minor") ((MINOR++)); PATCH=0;;
  "patch") ((PATCH++));;
  *) echo "Invalid type: $INCREMENT_MODE"; exit 1;;
esac

# Construct the new versionCode and versionName values
NEW_VERSION_CODE=$((VERSION_CODE + 1))
NEW_VERSION_NAME="$MAJOR.$MINOR.$PATCH"

# Update the build.gradle.kts.kts file with the new versionCode and versionName values
sed -i "s/versionCode = $VERSION_CODE/versionCode = $NEW_VERSION_CODE/" app/build.gradle.kts
sed -i "s/versionName = \"$VERSION_NAME\"/versionName = \"$NEW_VERSION_NAME\"/" app/build.gradle.kts

# Output the new versionCode and versionName values
#echo "New versionCode: $NEW_VERSION_CODE"
echo "$RELEASE_NOTES" > whatsnew/whatsnew-en-US
echo "$RELEASE_NOTES" > fastlane/metadata/android/en-US/changelogs/${NEW_VERSION_CODE}.txt

echo "v$NEW_VERSION_NAME"

