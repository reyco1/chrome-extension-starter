import { LitElement, html, css, unsafeCSS } from 'lit';
import { customElement, state } from 'lit/decorators.js';
import './components/draggable-container';
import styles from './styles.css';

@customElement('my-extension-component')
export class MyExtensionComponent extends LitElement {
    static styles = css`
    ${unsafeCSS(styles)}
  `;

    @state()
    private count = 0;

    private increment() {
        this.count++;
    }

    private close() {
        try {
            // Send message to parent window which will be caught by content script
            window.parent.postMessage({ type: 'component-close' }, '*');
        } catch (error) {
            console.error('Failed to dispatch close event:', error);
            // If we can't communicate with the parent, try to remove ourselves directly
            const component = this.closest('my-extension-component');
            if (component) {
                component.remove();
            }
        }
    }

    render() {
        return html`
      <draggable-container>
        <div class="flex flex-col items-center">
          <!-- Header with close button -->
          <div class="w-full flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-white">Web Component Extension</h2>
            <button 
              @click=${this.close}
              class="text-gray-400 hover:text-white"
              aria-label="Close"
            >
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M18 6L6 18M6 6l12 12"></path>
              </svg>
            </button>
          </div>
          
          <!-- Content -->
          <div class="bg-gray-800 rounded-lg p-6 w-full mb-6">
            <p class="text-gray-300 mb-4">
              This is a basic example of a web component extension. You can customize it to fit your needs.
            </p>
            
            <div class="flex flex-col items-center">
              <p class="text-2xl font-bold text-white mb-2">${this.count}</p>
              <button
                @click=${this.increment}
                class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md transition-colors"
              >
                Increment
              </button>
            </div>
          </div>
          
          <!-- Footer -->
          <p class="text-sm text-gray-500">
            v1.0.0 | Click and drag to move
          </p>
        </div>
      </draggable-container>
    `;
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-extension-component': MyExtensionComponent;
    }
}