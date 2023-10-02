class Select extends HTMLSelectElement {
  constructor() {
    super()
    if (this.options.length > 5) {
      this.items = []
      this.classList.add("hidden")
      this.createWrapper()
      this.createInput()
      this.createMenu()
    }
  }

  get options() {
    return this.querySelectorAll("option")
  }

  createWrapper() {
    this.wrapper = document.createElement("div")
    this.wrapper.classList.add("alchemy-select", "closed")
    this.after(this.wrapper)
    this.wrapper.addEventListener("click", (evt) => {
      console.log("Clicked on", evt.target)
      this.selectedItem = evt.target
      if (this.selectedItem) {
        this.inputField.value = this.selectedItem.textContent
      }
      this.wrapper.classList.toggle("closed")
      if (!this.wrapper.classList.contains("closed")) {
        this.inputField.focus()
      }
    })
  }

  createInput() {
    this.inputField = document.createElement("input")
    this.inputField.classList.add("alchemy-select--input")
    this.inputField.setAttribute("name", this.name)
    // this.inputField.placeholder = Alchemy.t("search")
    this.wrapper.appendChild(this.inputField)
    this.inputField.addEventListener("input", (evt) => this.updateOptions(evt))
  }

  createMenu() {
    this.menu = document.createElement("menu")
    this.options.forEach((option) => {
      const menuItem = document.createElement("li")
      menuItem.dataset.value = option.value
      menuItem.textContent = option.text
      this.menu.appendChild(menuItem)
      this.items.push(menuItem)
    })
    this.menu.classList.add("alchemy-select--menu", "closed")
    this.wrapper.appendChild(this.menu)
  }

  updateOptions(evt) {
    console.log(evt)
    const value = evt.target.value
    this.items.forEach((menuItem) => {
      if (menuItem.textContent.toLowerCase().includes(value.toLowerCase())) {
        menuItem.classList.remove("hidden")
      } else {
        menuItem.classList.add("hidden")
      }
    })
  }
}

customElements.define("alchemy-select", Select, { extends: "select" })
