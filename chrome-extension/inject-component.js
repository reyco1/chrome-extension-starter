// Check if script already exists
if (!document.querySelector('script[src*="bundle.js"]')) {
    // Create a script element to load the module
    const script = document.createElement('script');
    script.type = 'module';
    script.src = chrome.runtime.getURL('bundle.js');
    document.head.appendChild(script);
}