'use strict';

var SlackModal = React.createClass({

  propTypes: {
   url: React.PropTypes.string,
   slackToken: React.PropTypes.string,
   slackChannelId: React.PropTypes.string
  },
  defaultProps: {
   slackToken: '',
   slackChannelId: ''
  },

  getInitialState: function () {
    return {
      url: this.props.url,
      show: false,
      slackToken: this.props.slackToken,
      slackChannelId: this.props.slackChannelId
    };
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  _setValues: function(event) {
    var changed = {};
    changed[event.target.name] = event.target.value;
    this.setState(changed);
  },

  handleSaveClick: function() {
    $.ajax({
      data: {
        project: {
          slack_token: this.state.slackToken,
          slack_channel_id: this.state.slackChannelId
        }
      },
      dataType: 'json',
      url: this.props.url,
      type: 'put',
      context: this,

      success: function(){
        alert('Project Slack settings saved correctly');
        this._closeModal();
      }.bind(this),

      error: function(xhr, status, err){
        alert('Error saving Slack settings for this project');
      }.bind(this)
    });
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
                <a href="https://slack.com/oauth/authorize?scope=commands&client_id=6569426066.18297623252">
                  <img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcSet="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" />
                </a>
                <hr/>
                <h6>Settings</h6>
                <p>Save settings for this project.</p>
                <input id='slack-token' name='slackToken' type='text' placeholder='Slack token' onChange = {this._setValues} value={this.state.slackToken}></input>
                <input id='channel-id' name='slackChannelId' type='text' placeholder='Slack channel id' onChange = {this._setValues} value={this.state.slackChannelId}></input>
                  <a type='submit' className='save-settings' onClick={this.handleSaveClick}>
                    Save
                  </a>
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
