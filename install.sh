#!/bin/bash
# install.sh - Setup and build the Chrome extension project for development

# ----- Configuration -----
PROJECT_ROOT=$(pwd)                              # Current directory
WEB_COMPONENT_DIR="$PROJECT_ROOT/web-component"  # Web component directory
EXTENSION_DIR="$PROJECT_ROOT/chrome-extension"   # Chrome extension directory
ICONS_DIR="$EXTENSION_DIR/icons"                 # Icons directory

# ----- Logging Functions -----
log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
    exit 1
}

# ----- Step 1: Check Dependencies -----
log_info "Checking for required dependencies..."

# Check for Node.js and npm
if ! command -v node &> /dev/null; then
    log_error "Node.js is not installed. Please install Node.js before continuing."
fi

if ! command -v npm &> /dev/null; then
    log_error "npm is not installed. Please install npm before continuing."
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2)
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1)

if [ "$NODE_MAJOR" -lt 14 ]; then
    log_warning "Node.js version $NODE_VERSION detected. This project is recommended to run with Node.js v14 or higher."
else
    log_info "Node.js version $NODE_VERSION detected."
fi

# Check for jq command (used in deploy.sh)
if ! command -v jq &> /dev/null; then
    log_warning "jq is not installed. This is required for the deploy.sh script but not for installation."
    log_warning "Consider installing jq before deploying."
fi

# ----- Step 2: Install Web Component Dependencies -----
log_info "Installing web component dependencies..."

if [ ! -d "$WEB_COMPONENT_DIR" ]; then
    log_error "Web component directory '$WEB_COMPONENT_DIR' does not exist."
fi

cd "$WEB_COMPONENT_DIR" || log_error "Failed to change directory to '$WEB_COMPONENT_DIR'."

# Install dependencies
log_info "Running 'npm install' in '$WEB_COMPONENT_DIR'..."
npm install || log_error "npm install failed in '$WEB_COMPONENT_DIR'."

# Return to project root
cd "$PROJECT_ROOT" || log_error "Failed to return to project root."

# ----- Step 3: Create Icon Directory if Not Exists -----
log_info "Checking for icons directory..."

if [ ! -d "$ICONS_DIR" ]; then
    log_info "Icons directory not found. Creating '$ICONS_DIR'..."
    mkdir -p "$ICONS_DIR" || log_error "Failed to create icons directory."
    
    # Create placeholder icons if they don't exist
    # This is just a simple example to create blank PNG files as placeholders
    log_info "Creating placeholder icons..."
    
    # Function to create a colored square as a simple icon
    create_placeholder_icon() {
        local size=$1
        local output_file="$ICONS_DIR/$size.png"
        
        # Check if ImageMagick is installed
        if command -v convert &> /dev/null; then
            convert -size ${size}x${size} xc:#4285F4 "$output_file"
        else
            # If ImageMagick is not available, just create an empty file
            log_warning "ImageMagick not found. Creating empty icon placeholder."
            touch "$output_file"
        fi
    }
    
    # Create placeholder icons for common sizes
    create_placeholder_icon 16
    create_placeholder_icon 48
    create_placeholder_icon 128
    
    log_info "Placeholder icons created. Replace them with your actual icons."
else
    log_info "Icons directory already exists at '$ICONS_DIR'."
fi

# ----- Step 4: Build the Web Component -----
log_info "Building the web component..."

cd "$WEB_COMPONENT_DIR" || log_error "Failed to change directory to '$WEB_COMPONENT_DIR'."

# Build the web component
log_info "Running 'npm run build' in '$WEB_COMPONENT_DIR'..."
npm run build || log_error "npm run build failed in '$WEB_COMPONENT_DIR'."

# Return to project root
cd "$PROJECT_ROOT" || log_error "Failed to return to project root."

# ----- Step 5: Set correct permissions for the deploy script -----
log_info "Setting executable permissions for deploy.sh..."

if [ -f "./deploy.sh" ]; then
    chmod +x ./deploy.sh || log_warning "Failed to set executable permissions for deploy.sh"
else
    log_warning "deploy.sh script not found. Skipping permission update."
fi

# ----- Step 6: Add install.sh to gitignore -----
log_info "Updating .gitignore..."

if [ -f "./.gitignore" ]; then
    if ! grep -q "install.sh" ./.gitignore; then
        echo "install.sh" >> ./.gitignore
        log_info "Added install.sh to .gitignore"
    else
        log_info "install.sh already in .gitignore"
    fi
else
    echo "install.sh" > ./.gitignore
    log_info "Created .gitignore with install.sh"
fi

# ----- Step 7: Set executable permissions for the install script itself -----
chmod +x ./install.sh || log_warning "Failed to set executable permissions for install.sh"

# ----- Installation Complete -----
log_success "Installation completed successfully!"
log_info "You can now load the extension in Chrome:"
log_info "  1. Open Chrome and go to chrome://extensions/"
log_info "  2. Enable 'Developer mode' (toggle in the top right)"
log_info "  3. Click 'Load unpacked' and select the '$EXTENSION_DIR' directory"
log_info ""
log_info "To rebuild the component after making changes:"
log_info "  cd $WEB_COMPONENT_DIR && npm run build"
log_info ""
log_info "To package the extension for distribution:"
log_info "  ./deploy.sh"