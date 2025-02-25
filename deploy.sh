#!/bin/bash
# deploy.sh - Build web component and package Chrome extension for deployment with detailed logging

# ----- Configuration -----
WEB_COMPONENT_DIR="./web-component"                 # Directory for your web component (contains package.json with a build script)
EXTENSION_DIR="./chrome-extension"                  # Directory containing your Chrome extension source files (including manifest.json)
PACKAGE_JSON="$WEB_COMPONENT_DIR/package.json"      # Path to web component's package.json
MANIFEST="$EXTENSION_DIR/manifest.json"             # Path to extension's manifest.json
MAIN_COMPONENT="$WEB_COMPONENT_DIR/src/index.ts"    # Path to main component

# ----- Logging Functions -----
# Log info messages with a timestamp
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Log error messages with a timestamp and exit
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
    exit 1
}

# ----- Step 1: Get Version from package.json -----
log_info "Getting version from package.json"

if [ ! -f "$PACKAGE_JSON" ]; then
    log_error "package.json not found at '$PACKAGE_JSON'"
fi

# Extract version from package.json using grep and sed
VERSION=$(grep -m1 '"version":' "$PACKAGE_JSON" | sed -E 's/.*"version": "([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
    log_error "Failed to extract version from package.json"
fi

log_info "Found version: $VERSION"

# Set the output zip filename with version
OUTPUT_ZIP="chrome-extension-v$VERSION.zip"

# ----- Step 2: Update manifest.json version -----
log_info "Updating manifest.json version to $VERSION"

if [ ! -f "$MANIFEST" ]; then
    log_error "manifest.json not found at '$MANIFEST'"
fi

# Create a temporary file
TMP_MANIFEST=$(mktemp)

# Update version in manifest.json
jq ".version = \"$VERSION\"" "$MANIFEST" > "$TMP_MANIFEST"

if [ $? -ne 0 ]; then
    rm "$TMP_MANIFEST"
    log_error "Failed to update version in manifest.json"
fi

# Move the temporary file back to the original
mv "$TMP_MANIFEST" "$MANIFEST"

log_info "Successfully updated manifest.json version"

# ----- Step 3: Build the Web Component -----
log_info "Building the web component."

if [ ! -d "$WEB_COMPONENT_DIR" ]; then
    log_error "Web component directory '$WEB_COMPONENT_DIR' does not exist."
fi

log_info "Changing directory to '$WEB_COMPONENT_DIR'."
cd "$WEB_COMPONENT_DIR" || log_error "Failed to change directory to '$WEB_COMPONENT_DIR'."

log_info "Running 'npm run build' in '$WEB_COMPONENT_DIR'."
npm run build || log_error "npm run build failed in '$WEB_COMPONENT_DIR'."

log_info "Web component built successfully."

# Return to the project root.
cd - >/dev/null || log_error "Failed to return to the project root."

# ----- Step 4: Package the Chrome Extension -----
log_info "Packaging the Chrome extension."

if [ ! -d "$EXTENSION_DIR" ]; then
    log_error "Extension directory '$EXTENSION_DIR' does not exist."
fi

log_info "Creating ZIP file '$OUTPUT_ZIP'."
cd "$EXTENSION_DIR" || log_error "Failed to change directory to '$EXTENSION_DIR'."

# Create the ZIP file, excluding hidden files and directories
zip -r "../$OUTPUT_ZIP" . -x ".*" "*/.*" || log_error "Failed to create ZIP file."

cd - >/dev/null || log_error "Failed to return to the project root."

log_info "Successfully created '$OUTPUT_ZIP'."
log_info "Deployment process completed successfully."