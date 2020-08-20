import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | folder-show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders with data", async function(assert) {
    this.set("folder", {
      name: "It-Ninjas",
      accounts: [{ accountname: "Ninjas account" }]
    });

    await render(hbs`<FolderShow @folder={{this.folder}}/>`);

    let text = this.element.textContent.trim();
    assert.ok(text.includes("It-Ninjas"));
  });
});
