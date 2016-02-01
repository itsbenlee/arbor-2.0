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
      slackChannelId: this.props.slackChannelId,
      channelsList: []
    };
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  _handleChannelIdChange: function(event) {
    this.setState({slackChannelId: event.target.value});
  },

  _handleSlackTokenChange: function(event) {
    this.setState({slackToken: event.target.value});
    $.ajax({
      url: '/api_slack/channels',
      dataType: 'JSON',
      method: 'GET',
      data: { token:  event.target.value},
      success: function (response) {
        var workingChannels = JSON.parse(response.data.working_channels);
        for (var i = 0; i < workingChannels.length; i++) {
            var channel = workingChannels[i];
            this.state.channelsList.push(channel);
        }
        this.forceUpdate();
      }.bind(this)
    });
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
                  <a href="https://slack.com/oauth/authorize?scope=commands channels:read&client_id=6569426066.18297623252">
                    <img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcSet="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" />
                  </a>
                <hr/>
                <h6>Settings</h6>
                <p>Save settings for this project.</p>
                <input id='slack-token' name='slackToken' type='text' placeholder='Slack token' onChange = {this._handleSlackTokenChange} value={this.state.slackToken}></input>
                <select id='channel-id' name='slackChannelId' onChange = {this._handleChannelIdChange}>
                  {
                    this.state.channelsList.map(function(channel, index) {
                      return <option key={index} value={channel.id}> {channel.name} </option>
                    })
                  }
                </select>
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
