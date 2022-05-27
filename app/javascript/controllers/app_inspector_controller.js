import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"];

  submitForm(event) {
    this.formTarget.requestSubmit()
  }
}
