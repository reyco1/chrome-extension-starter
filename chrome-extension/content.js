console.log('Content Script: Initialized');

// Listen for messages from the web component
window.addEventListener('message', function (event) {
    // Verify the message is from our web component
    if (event.data && event.data.type === 'component-close') {
        try {
            // Relay the message to the background script
            chrome.runtime.sendMessage({ type: 'component-close' })
                .catch(error => {
                    console.log('Failed to send message to background script:', error);
                    // If extension context is invalid, just remove the component directly
                    const component = document.querySelector('my-extension-component');
                    if (component) {
                        component.remove();
                    }
                });
        } catch (error) {
            console.log('Extension context invalid, removing component directly');
            // If chrome.runtime is not available, remove the component directly
            const component = document.querySelector('my-extension-component');
            if (component) {
                component.remove();
            }
        }
    }
});

// Listen for messages from the background script
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.type === 'remove-component') {
        const component = document.querySelector('my-extension-component');
        if (component) {
            component.remove();
            try {
                // Update the background script's state
                chrome.runtime.sendMessage({ type: 'component-removed' })
                    .catch(error => console.log('Failed to send component-removed message:', error));
            } catch (error) {
                console.log('Failed to send component-removed message:', error);
            }
        }
    }
    // Always send a response
    sendResponse({ received: true });
});