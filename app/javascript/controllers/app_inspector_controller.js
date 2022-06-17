import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider", "xLabel"];

  submitForm(event) {
    this.formTarget.requestSubmit();
  }

  updateBinCount(event) {
    this.binCountLabelTarget.textContent = this.binCountSliderTarget.value;
    this.formTarget.requestSubmit();
  }

  updateProperty(event) {
    this.xLabelTarget.textContent = `${event.target.value} per job`;
    this.formTarget.requestSubmit();
  }
}
