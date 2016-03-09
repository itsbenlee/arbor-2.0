'use strict';

var slackEnabled;

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

    slackEnabled = this.props.slackEnabled;
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
      },
      slackEnabled: slackEnabled
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
    if (this.state.slackEnabled !== slackEnabled) {
      slackEnabled = this.state.slackEnabled;
      $.ajax({
        url: '/api_slack/slack/toggle_notifications?project_id=' + this.props.projectId
      });
    }
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
          <p className="details">Connect your slack account with Arbor to send activity updates for
          this project to a selected Slack Channel.</p>
          <a href={slackHref} className="save-settings">Connect to Slack</a>
        </div>
      );

      if (this.state.isAuthorized) {
        slackIntegration = null;
        slackSettings = (
          <div>
            <h3>Slack Configuration</h3>
            <div className="slack-success" style={this.state.slackEnabled ? SlackModalStyles.toggle.constainer.enabled : SlackModalStyles.toggle.constainer.disabled}>
              <span>Send project activity to Slack</span>
              <div onClick={() => this._toggleSlack()} className="toggle-button"
                style={this.state.slackEnabled ? SlackModalStyles.toggle.enabled : SlackModalStyles.toggle.disabled}>
                <div className="in-toggle-button"
                  style={this.state.slackEnabled ? SlackModalStyles.toggle.main.enabled : SlackModalStyles.toggle.main.disabled}></div>
              </div>
            </div>
            <a type='submit' className='save-settings' onClick={this.handleSaveClick}>
              Done
            </a>
          </div>
        );
      } else if (this.state.slack.status === 'error') {
        slackIntegration = null;
        slackSettings = (
          <div style={{textAlign: 'center'}}>
            <h3>Slack Configuration</h3>
            <p className="details">Error saving Slack settings for this project</p>
            <a className='save-settings' onClick={this._closeModal}>
              Ok
            </a>
          </div>
        );
      } else if (typeof this.state.isAuthorized === 'undefined') {
        slackIntegration = null;
        this._testAuth();
        slackSettings = (
          <div>
            <p className="details">Loading</p>
          </div>
        );
      }

      return (
        <div className="slack-modal modal">
          <div className="modal-container">
            <a className="modal-close-btn" href="#" onClick={this._closeModal}>×</a>
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
    var context = this;
    this.setState({
      show: data ? data.toggle : false || false
    });
    if (data) {
      this._testAuth();
    }
  },

  _testAuth() {
    var context = this;
    var isAuthorized;
    $.ajax({
      url: '/api_slack/slack/test_auth?project_id=' + this.props.projectId
    }).done(function(data) {
      context.setState({
        isAuthorized: data.authorized
      });
    });
  },

  _closeModal: function () {
    var context = this;
    setTimeout(function(){context._toggleModal();},0);
  },

  _toggleSlack: function () {
    this.setState({
      slackEnabled: !this.state.slackEnabled
    });
  }
});

var Colors = {
  success: '#2ecc71',
  lightGray: '#F2F2F2',
  gray: '#DEDEDE'
};

var SlackModalStyles = {
  toggle: {
    main: {
      enabled: {
        borderColor: Colors.success,
        marginLeft: 15
      },
      disabled: {
        borderColor: Colors.gray
      }
    },
    enabled: {
      backgroundColor: Colors.success,
      borderColor: Colors.success
    },
    disabled: {
      backgroundColor: Colors.lightGray,
      borderColor: Colors.lightGray
    },
    constainer: {
      enabled: {
        borderColor: Colors.success
      },
      disabled: {
        borderColor: Colors.gray
      }
    }
  }
};
