import { afterEach, beforeEach } from "vitest";
import { LegalogyApp } from "../app.ts";

// oxlint-disable-next-line typescript/unbound-method
const originalConnect = LegalogyApp.prototype.connect;

export function mountApp(pathname: string) {
  window.history.replaceState({}, "", pathname);
  const app = document.createElement("legalogy-app") as LegalogyApp;
  document.body.append(app);
  return app;
}

export function registerAppMountHooks() {
  beforeEach(() => {
    LegalogyApp.prototype.connect = () => {
      // no-op: avoid real gateway WS connections in browser tests
    };
    window.__LEGALOGY_CONTROL_UI_BASE_PATH__ = undefined;
    localStorage.clear();
    document.body.innerHTML = "";
  });

  afterEach(() => {
    LegalogyApp.prototype.connect = originalConnect;
    window.__LEGALOGY_CONTROL_UI_BASE_PATH__ = undefined;
    localStorage.clear();
    document.body.innerHTML = "";
  });
}
