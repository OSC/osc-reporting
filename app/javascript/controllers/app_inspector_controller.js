import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("inspector connected");
  }

  setApp(event) {
    console.log("App changed to ");
    console.log(event.target.value);
    //form.requestSubmit()
  }
  
  setBins(event) {
    console.log("Number of bins changed to ");
    console.log(event.target.value);
    //form.requestSubmit()
  }
}
