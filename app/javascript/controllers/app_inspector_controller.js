import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["form", "binCountLabel", "binCountSlider"];
  
  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "InspectorChannel",
        // id: this.data.get("id"),
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  _connected(event) {
    console.log('connected');
    console.log(event);
  }

  _disconnected(event) {
    console.log('disconnected');
    console.log(event);
  }

  _received(event) {
    console.log('received');
    console.log(event);
  }

  onFormSubmit(event) {
    event.preventDefault();
    const data = {
      body: 'test'
    }
    this.subscription.send({message: data})
  }

  submitForm(event) {
    this.formTarget.requestSubmit();
  }

  updateBinCount(event) {
    this.binCountLabelTarget.textContent = this.binCountSliderTarget.value;
    this.formTarget.requestSubmit();
  }
}
