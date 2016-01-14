'use strict';

function SlackModalStore() {

  this.bindListeners({
    toggle: SlackModalActions.toggle
  });
  
}

SlackModalStore.prototype.toggle = function () {}

SlackModalStore.displayName = 'SlackModalStore';

window.SlackModalStore = alt.createStore(SlackModalStore);