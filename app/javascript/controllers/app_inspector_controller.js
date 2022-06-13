import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider", "clusterSelect", "appSelect", "histogramContainer"];
  
  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "InspectorChannel",
        room: "main"
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
        getHistogram: function(reqBody) {
          this.perform('get_histogram', {body: reqBody});
        }
      }
    );
  }

  _connected(event) {
    console.log('inspectorChannel connected');
  }

  _disconnected(event) {
    console.log('inspectorChannel disconnected');
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
