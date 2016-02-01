'use strict';

function SlackModalStore() {

  this.bindListeners({
    toggle: SlackModalActions.TOGGLE
  });

}

SlackModalStore.prototype.toggle = function (data) {
  this.setState({
    toggle: data
  });
};

SlackModalStore.displayName = 'SlackModalStore';

window.SlackModalStore = alt.createStore(SlackModalStore);
