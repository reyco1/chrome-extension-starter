import { LitElement, html, css, unsafeCSS } from 'lit';
import { customElement, state } from 'lit/decorators.js';
import styles from '../styles.css';

@customElement('draggable-container')
export class DraggableContainer extends LitElement {
    static styles = css`
    ${unsafeCSS(styles)}
    :host {
      position: fixed;
      cursor: move;
      user-select: none;
      -webkit-user-select: none;
      z-index: 1000;
    }
  `;

    @state()
    private isDragging = false;

    @state()
    private position = { x: window.innerWidth - 420, y: 20 };

    @state()
    private dragOffset = { x: 0, y: 0 };

    connectedCallback() {
        super.connectedCallback();
        // Set initial position
        this.style.left = `${this.position.x}px`;
        this.style.top = `${this.position.y}px`;

        // Handle window resize
        window.addEventListener('resize', this.handleResize);
    }

    disconnectedCallback() {
        super.disconnectedCallback();
        window.removeEventListener('resize', this.handleResize);
    }

    private handleMouseDown(e: MouseEvent) {
        // Only handle left mouse button
        if (e.button !== 0) return;

        const target = e.target as HTMLElement;
        // Don't initiate drag on interactive elements
        if (target.tagName === 'INPUT' ||
            target.tagName === 'BUTTON' ||
            target.tagName === 'A' ||
            target.tagName === 'LABEL') {
            return;
        }

        this.isDragging = true;
        const rect = this.getBoundingClientRect();
        this.dragOffset = {
            x: e.clientX - rect.left,
            y: e.clientY - rect.top
        };

        // Add temporary event listeners
        window.addEventListener('mousemove', this.handleMouseMove);
        window.addEventListener('mouseup', this.handleMouseUp);
    }

    private handleMouseMove = (e: MouseEvent) => {
        if (!this.isDragging) return;

        this.position = {
            x: e.clientX - this.dragOffset.x,
            y: e.clientY - this.dragOffset.y
        };

        this.style.left = `${this.position.x}px`;
        this.style.top = `${this.position.y}px`;
    };

    private handleMouseUp = () => {
        this.isDragging = false;
        window.removeEventListener('mousemove', this.handleMouseMove);
        window.removeEventListener('mouseup', this.handleMouseUp);
    };

    private handleResize = () => {
        if (!this.isDragging) {
            // Keep the component in view when window is resized
            const rect = this.getBoundingClientRect();
            const maxX = window.innerWidth - rect.width;
            this.position.x = Math.min(this.position.x, maxX - 20);
            this.style.left = `${this.position.x}px`;
        }
    };

    render() {
        return html`
      <div 
        @mousedown=${this.handleMouseDown}
        class="w-[400px] bg-gray-900 rounded-xl shadow-2xl p-8 flex flex-col select-none"
        style="touch-action: none;"
      >
        <slot></slot>
      </div>
    `;
    }
}