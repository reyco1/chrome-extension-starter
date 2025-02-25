# 🧩 Web Component Chrome Extension

<div align="center">

![Chrome Extension](https://img.shields.io/badge/Chrome-Extension-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white)
![Web Components](https://img.shields.io/badge/Web-Components-29ABE2?style=for-the-badge&logo=webcomponents.org&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Lit](https://img.shields.io/badge/Lit-324FFF?style=for-the-badge&logo=lit&logoColor=white)

A modern Chrome extension that injects a draggable web component into any webpage.

[Features](#-features) •
[Installation](#-installation) •
[Usage](#-usage) •
[Development](#-development) •
[Building](#-building) •
[Project Structure](#-project-structure) •
[Customization](#-customization)

</div>

## ✨ Features

- **Draggable Component** - Inject a draggable UI component into any webpage
- **State Management** - Simple state management with counter example
- **Modern Technologies** - Built with TypeScript, Lit, and Tailwind CSS
- **Responsive** - Automatically adjusts to window resizing
- **Lightweight** - Minimal bundle size for optimal performance
- **Easy to Extend** - Modular architecture for easy customization

## 🔧 Installation

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [npm](https://www.npmjs.com/) (usually comes with Node.js)
- [jq](https://stedolan.github.io/jq/download/) (optional, for deployment)

### Automatic Installation

Run the installation script to set up the project:

```bash
# Make the script executable
chmod +x install.sh

# Run the installation script
./install.sh
```

### Manual Installation

If you prefer to install manually:

1. Install web component dependencies:

   ```bash
   cd web-component
   npm install
   ```
2. Build the web component:

   ```bash
   npm run build
   ```
3. Ensure the icons directory exists:

   ```bash
   mkdir -p chrome-extension/icons
   ```

## 🚀 Usage

### Loading the Extension in Chrome

1. Open Chrome and navigate to `chrome://extensions/`
2. Enable **Developer mode** (toggle in the top-right corner)
3. Click **Load unpacked**
4. Select the `chrome-extension` directory from this project

### Using the Extension

1. Click the extension icon in your Chrome toolbar
2. The component will appear on the current webpage
3. Click and drag to move the component around
4. Click the counter button to increment its value
5. Click the X button or the extension icon again to remove the component

## 💻 Development

### Web Component

The web component is built with [Lit](https://lit.dev/) and TypeScript:

```bash
# Navigate to web-component directory
cd web-component

# Start development with auto-rebuild
npm run dev
```

After making changes, reload the extension in Chrome to see your updates.

### Extension

To modify the Chrome extension behavior:

1. Edit files in the `chrome-extension` directory
2. Go to `chrome://extensions/`
3. Click the refresh icon on your extension
4. Reload the current webpage

## 🔨 Building

### Development Build

```bash
cd web-component
npm run build
```

### Production Deployment

Use the deploy script to build and package the extension:

```bash
# Make the script executable (if not already)
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

This will:

1. Update the version in `manifest.json`
2. Build the web component
3. Package the extension into a ZIP file ready for distribution

## 📁 Project Structure

```
.
├── chrome-extension/           # Chrome extension files
│   ├── background.js           # Background service worker
│   ├── bundle.js               # Compiled web component
│   ├── content.js              # Content script
│   ├── icons/                  # Extension icons
│   ├── inject-component.js     # Script to inject the component
│   └── manifest.json           # Extension manifest
│
├── web-component/              # Web component source
│   ├── src/
│   │   ├── components/         # Component files
│   │   │   └── draggable-container.ts
│   │   ├── types/              # TypeScript type definitions
│   │   ├── index.ts            # Main component entry point
│   │   └── styles.css          # Tailwind CSS imports
│   ├── package.json            # Dependencies and scripts
│   ├── rollup.config.js        # Bundler configuration
│   ├── tailwind.config.cjs     # Tailwind CSS configuration
│   └── tsconfig.json           # TypeScript configuration
│
├── deploy.sh                   # Deployment script
├── install.sh                  # Installation script
└── README.md                   # This file
```

## 🎨 Customization

### Modifying the Component UI

To customize the component's appearance:

1. Edit `web-component/src/index.ts` to change the HTML structure
2. Modify Tailwind CSS classes for styling
3. Run `npm run build` to rebuild

### Adding New Functionality

To add new features:

1. Create new components in `web-component/src/components/`
2. Import and use them in `index.ts`
3. Add new state properties with the `@state()` decorator
4. Rebuild and test your changes

### Extension Options

To modify extension behavior:

1. Edit `chrome-extension/background.js` for background operations
2. Edit `chrome-extension/content.js` for page interaction logic
3. Update `chrome-extension/manifest.json` for metadata and permissions

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- [Lit](https://lit.dev/) - For the lightweight component library
- [Tailwind CSS](https://tailwindcss.com/) - For utility-first styling
- [Rollup](https://rollupjs.org/) - For bundling
- [TypeScript](https://www.typescriptlang.org/) - For type safety

---

Rey<div align="center">

<p>Made with ❤️ by Reyco1</p>
  <p>
    <a href="https://github.com/yourusername/web-component-extension">GitHub</a> •
    <a href="https://github.com/yourusername/web-component-extension/issues">Report Bug</a> •
    <a href="https://github.com/yourusername/web-component-extension/issues">Request Feature</a>
  </p>
</div>
