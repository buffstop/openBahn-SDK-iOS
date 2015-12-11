#!/bin/sh
set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

SF_TARGET_NAME=${PROJECT_NAME}
SF_EXECUTABLE_PATH="lib${SF_TARGET_NAME}.a"
SF_WRAPPER_NAME="${SF_TARGET_NAME}.framework"

# The following conditionals come from
# https://github.com/kstenerud/iOS-Universal-Framework

if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
then
SF_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
then
SF_OTHER_PLATFORM=iphonesimulator
else
SF_OTHER_PLATFORM=iphoneos
fi

if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$SF_SDK_PLATFORM$ ]]
then
SF_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${SF_OTHER_PLATFORM}"
else
echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
exit 1
fi

# Build the other platform.
xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk ${SF_OTHER_PLATFORM}${SF_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

#// vars for framework structure
SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}.a" &&
DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}.a" &&
UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal" &&
UNIVERSAL_LIBRARY_PATH="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}" &&
FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}.framework" &&
FRAMEWORK_HEADER_PATH="${FRAMEWORK}/Versions/A/Headers/" &&
SIMULATOR_LIBRARY_HEADERS="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/include/${PRODUCT_NAME}/" &&
FAT_LIB_DIR="${PROJECT_DIR}/fatLib" &&

# Create framework directory structure.
rm -rf "${FRAMEWORK}" &&
mkdir -p "${UNIVERSAL_LIBRARY_DIR}" &&
mkdir -p "${FRAMEWORK}/Versions/A/Headers" &&
mkdir -p "${FRAMEWORK}/Versions/A/Resources" &&

# Generate universal binary for the device and simulator.
lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${UNIVERSAL_LIBRARY_PATH}" &&

# Move files to appropriate locations in framework paths.
cp "${UNIVERSAL_LIBRARY_PATH}" "${FRAMEWORK}/Versions/A" &&
ln -s "A" "${FRAMEWORK}/Versions/Current" &&
ln -s "Versions/Current/Headers" "${FRAMEWORK}/Headers" &&
ln -s "Versions/Current/Resources" "${FRAMEWORK}/Resources" &&
ln -s "Versions/Current/${PRODUCT_NAME}" "${FRAMEWORK}/${PRODUCT_NAME}"

#copy Headers
cp -a "${SIMULATOR_LIBRARY_HEADERS}." "${FRAMEWORK_HEADER_PATH}" &&

#copy ready made fat lib to fatLib dir
mkdir -p "${FAT_LIB_DIR}/${PRODUCT_NAME}.framework"
cp -r "${FRAMEWORK}/" "${FAT_LIB_DIR}/${PRODUCT_NAME}.framework"
#open "${UNIVERSAL_LIBRARY_PATH}"
