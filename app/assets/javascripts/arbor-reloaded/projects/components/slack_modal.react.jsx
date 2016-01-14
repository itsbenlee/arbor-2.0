'use strict';

var SlackModal = React.createClass({

  getInitialState: function () {
    return {
      show: false
    };
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  render: function() {
    if (this.state.show) {
      return (
        <div className="slack-modal modal">
          <div className="modal-container">
            <a className="modal-close-btn" href="#" onClick={this._closeModal}>×</a>
            <h5>Configure Slack</h5>
            <div className="modal-content">
              <div className="legend">
                <h6>Slack Integration</h6>
                <p>Creates a new Arbor User Story from Slack.</p>
              </div>
              <a href="https://slack.com/oauth/authorize?scope=commands&client_id=6569426066.18297623252">
                <img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcSet="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" />
              </a>
            </div>
          </div>
          <div className="modal-bg" onClick={this._closeModal}></div>
        </div>
      );
    }
    return null;
  },

  _toggleModal: function (show) {
    this.setState({
      show: show
    });
  },

  _closeModal: function () {
    this._toggleModal();
  }

});