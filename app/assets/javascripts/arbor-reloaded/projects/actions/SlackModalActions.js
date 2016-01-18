'use strict';

function SlackModalActions() {}

SlackModalActions.prototype.toggle = function (data) {
  return data;
};

SlackModalActions.displayName = 'SlackModalActions';

window.SlackModalActions = alt.createActions(SlackModalActions);