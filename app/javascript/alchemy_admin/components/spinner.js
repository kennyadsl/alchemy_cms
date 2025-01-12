import { AlchemyHTMLElement } from "./alchemy_html_element"

class Spinner extends AlchemyHTMLElement {
  static properties = {
    size: { default: "medium" },
    color: { default: "currentColor" }
  }

  render() {
    this.className = `spinner spinner--${this.size}`

    return `
      <svg width="100%" viewBox="0 0 28 28" style="--spinner-color: ${this.color}">
        <path
          class="hex1"
          d="M5.938,18.07l-5.878-5.9l2.154-8.058l8.024-2.161l5.87,5.9l-2.144,8.058L5.938,18.07z"
        />
        <path
          class="hex2"
          d="M19.686,20.785l-4.731-4.754l1.725-6.487l6.468-1.742l4.733,4.754l-1.734,6.487L19.686,20.785z"
        />
        <path
          class="hex3"
          d="M11.708,26.294l-3.47-3.485l1.276-4.758l4.74-1.276l3.468,3.485l-1.265,4.758L11.708,26.294z"
        />
      </svg>
    `
  }
}

customElements.define("alchemy-spinner", Spinner)
