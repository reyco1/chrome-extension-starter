let isInjected = false;

chrome.action.onClicked.addListener(async (tab) => {
    if (!isInjected) {
        // Inject the module loader script
        await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            files: ['inject-component.js']
        });

        // Then inject the script to add the component to the page
        await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            function: injectComponent
        });

        isInjected = true;
    } else {
        // Remove the component
        await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            function: removeComponent
        });

        isInjected = false;
    }
});

// Listen for the close event from the component
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.type === 'component-close' && sender.tab) {
        chrome.tabs.sendMessage(sender.tab.id, { type: 'remove-component' });
    } else if (message.type === 'component-removed') {
        isInjected = false;
    }
    // Make sure to send a response
    sendResponse({ received: true });
});

function injectComponent() {
    // Wait a short moment for the module to load
    setTimeout(() => {
        const component = document.createElement('my-extension-component');
        component.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      z-index: 2147483647;
    `;
        document.body.appendChild(component);
    }, 100);
}

function removeComponent() {
    const component = document.querySelector('my-extension-component');
    if (component) {
        component.remove();
    }
    // Remove the injected script
    const scriptElement = document.querySelector('script[src*="bundle.js"]');
    if (scriptElement) {
        scriptElement.remove();
    }
}