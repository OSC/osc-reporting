// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";


import * as Turbo from "@hotwired/turbo";

window.addEventListener('turbo:load', (event) => {
    // Reload page after a given amount of time
    const SECONDS_BEFORE_RELOAD = 15 * 60;
    setTimeout(() => {
      Turbo.visit(window.location.toString(), { action: 'replace' });
    }, 1000 * SECONDS_BEFORE_RELOAD);
});
