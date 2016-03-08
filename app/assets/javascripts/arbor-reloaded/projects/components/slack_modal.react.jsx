'use strict';

var SlackModal = React.createClass({

  propTypes: {
   url: React.PropTypes.string,
  },

  getInitialState: function () {
    var urlParams,
        match,
        pl = /\+/g,  // Regex for replacing addition symbol with a space
        search = /([^&=]+)=?([^&]*)/g,
        decode = function (s) {return decodeURIComponent(s.replace(pl, ' '))},
        query = window.location.search.substring(1);

      urlParams = {};
      while (match = search.exec(query)) {
        urlParams[decode(match[1])] = decode(match[2]);
      }

    return {
      url: this.props.url,
      show: urlParams.hasOwnProperty('slack_status') ? true : false,
      slack: {
        status: urlParams.slack_status || '',
        token: this.props.authToken || ''
      }
    };
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  handleSaveClick: function() {
    this._closeModal();
  },

  render: function() {
    if (this.state.show) {

      var slackSettings,
          slackIntegration,
          slackHref = location.protocol + '//' + location.host +
          '/api_slack/slack/authorize?project_id=' + this.props.projectId;

      slackIntegration = (
        <div>
          <h3>Slack Configuration</h3>
          <p>Connect your slack account with Arbor to send activity updates for
          this project to a selected Slack Channel.</p>
          <a href={slackHref}>Connect to Slack</a>
        </div>
      );

      if (this.state.slack.status === 'success') {
        slackIntegration = null;
        slackSettings = (
          <div>
            <h3>Slack Configuration</h3>
            <div>
              <span>Send project activity to Slack</span>
              
            </div>
            <a type='submit' className='save-settings' onClick={this.handleSaveClick} style={{position: 'relative', float: 'right', marginTop: 10, marginBottom: 30, right: 0}}>
              Done
            </a>
          </div>
        );
      } else if (this.state.slack.status === 'error') {
        slackSettings = (
          <div>
            <p>Error saving Slack settings for this project</p>
          </div>
        );
      }

      return (
        <div className="slack-modal modal">
          <div className="modal-container">
            <a className="modal-close-btn" href="#" onClick={this._closeModal}>×</a>
            <h5>Configure Slack</h5>
            <div className="modal-content">
              <div className="legend">
                {slackIntegration}
                {slackSettings}
              </div>
            </div>
          </div>
          <div className="modal-bg" onClick={this._closeModal}></div>
        </div>
      );
    }
    return null;
  },

  _toggleModal: function (data) {
    this.setState({
      show: data ? data.toggle : false || false
    });
  },

  _closeModal: function () {
    this._toggleModal();
  }
});
