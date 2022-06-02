import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider"];

  submitForm(event) {
    this.formTarget.requestSubmit();
  }

  updateBinCount(event) {
    this.binCountLabelTarget.textContent = this.binCountSliderTarget.value;
    this.formTarget.requestSubmit();
  }
}
