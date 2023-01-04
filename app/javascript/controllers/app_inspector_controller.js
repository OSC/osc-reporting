import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider", "xLabel"];

  submitForm(event) {
    this.formTarget.requestSubmit();
  }

  updateBinCount(event) {
    // If bin slider is set to 21, show "1 per" as number of bins, otherwise show the set value
    this.binCountLabelTarget.textContent = this.binCountSliderTarget.value == 21 ? "max" : this.binCountSliderTarget.value;
    this.formTarget.requestSubmit();
  }

  updateProperty(event) {
    this.xLabelTarget.textContent = `${event.target.value} per job`;
    this.formTarget.requestSubmit();
  }
}
