import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider", "clusterSelect", "appSelect", "histogramContainer"];
  
  connect() {
    this.subscription = createConsumer().subscriptions.create(
      {
        channel: "InspectorChannel",
        room: "main"
      },
      {
        connected: function(event) {
          console.log('inspectorChannel connected');
        },
        disconnected: function(event) {
          console.log('inspectorChannel disconnected');
        },
        received: this._received.bind(this),
        getHistogram: function(reqBody) {
          this.perform('get_histogram', {body: reqBody});
        }
      }
    );
  }

  _received(event) {
    console.log('received');
    this.histogramContainerTarget.innerHTML = event;
  }

  requestReload(event) {
    event.preventDefault();
    const data = {
      bins: this.binCountSliderTarget.value,
      app: this.appSelectTarget.value,
      cluster: this.clusterSelectTarget.value
    }
    this.subscription.getHistogram(data)
  }

  submitForm(event) {
    this.formTarget.requestSubmit();
  }

  updateBinCount(event) {
    this.binCountLabelTarget.textContent = this.binCountSliderTarget.value;
    this.formTarget.requestSubmit();
  }
}
