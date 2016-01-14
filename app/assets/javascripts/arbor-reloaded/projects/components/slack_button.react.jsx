'use strict';

var SlackButton = React.createClass({

  render: function() {
    return (
      <div className="slack-button">
        <a onClick={this._showSlackModal} className="configure-slack">Configure Slack
          <span className="icn-slack"></span>
        </a>
      </div>
    );
  },

  _showSlackModal: function (e) {
    SlackModalActions.toggle(true);
  }

});