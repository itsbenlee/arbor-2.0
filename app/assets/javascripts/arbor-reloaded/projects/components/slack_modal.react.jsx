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
        enabled: slackEnabled
      }
    };
  },

  componentDidMount: function () {
    this._testAuth();
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  handleSaveClick: function() {
    this._closeModal();
    if (this.state.slack.enabled === slackEnabled) return;
    slackEnabled = this.state.slack.enabled;
    $.ajax({
      url: '/api_slack/slack/toggle_notifications?project_id=' + this.props.projectId
    });
  },

  render: function() {
    if (this.state.show) {

      var modalContent,
          slackHref = location.protocol + '//' + location.host +
          '/api_slack/slack/authorize?project_id=' + this.props.projectId;

      modalContent = (typeof this.state.isAuthorized === 'undefined')
        ? <div><p className="details">Loading</p></div>
        : <ModalContent state={this.state} props={this.props} actions={{
          close: this._closeModal,
          integrate: slackHref,
          toggle: this._toggleSlack,
          save: this.handleSaveClick
        }}/>;

      return (
        <div className="slack-modal modal">
          <div className="modal-container">
            <a className="modal-close-btn" href="#" onClick={this._closeModal}>×</a>
            <div className="modal-content">
              <div className="legend">
                {modalContent}
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
    this.state.slack.enabled = !this.state.slack.enabled;
    this.forceUpdate();
  }
});

function SlackIntegration (props) {
  return (
    <div>
      <h3>Slack Configuration</h3>
      <p className="details">Connect your slack account with Arbor to send activity updates for
      this project to a selected Slack Channel.</p>
      <a href={props.action} className="save-settings">Connect to Slack</a>
    </div>
  );
}

function SlackSettings (props) {
  return (
    <div>
      <h3>Slack Configuration</h3>
      <div className={(props.enabled ? 'enabled' : 'disabled') + ' slack-success'}>
        <span>Send project activity to Slack</span>
        <div onClick={props.onToggle} className="toggle-button">
          <div className="in-toggle-button"></div>
        </div>
      </div>
      <a type='submit' className='save-settings' onClick={props.onSave}>
        Done
      </a>
    </div>
  );
}

function SlackError (props) {
  return (
    <div style={{textAlign: 'center'}}>
      <h3>Slack Configuration</h3>
      <p className="details">Error saving Slack settings for this project</p>
      <a className='save-settings' onClick={props.action}>
        Ok
      </a>
    </div>
  );
}

function ModalContent (props) {
  return (
    <div>
      {props.state.slack.status === 'error'
        ? <SlackError action={props.actions.close}/>
        : null}
      {props.state.isAuthorized && props.props.slackConnected
        ? <SlackSettings
            enabled={props.state.slack.enabled}
            onToggle={props.actions.toggle}
            onSave={props.actions.save}/>
        : null}
      {!props.props.slackConnected && props.state.slack.status !== 'error'
        ? <SlackIntegration action={props.actions.integrate}/>
        : null}
    </div>
  );
}
