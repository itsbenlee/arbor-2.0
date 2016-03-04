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
        decode = function (s) {
          return decodeURIComponent(s.replace(pl, ' '));
        },
        query = window.location.search.substring(1);

      urlParams = {};
      while (match = search.exec(query)) {
        urlParams[decode(match[1])] = decode(match[2]);
      }

    return {
      url: this.props.url,
      show: false,
      slack: {
        status: urlParams.slack_status || '',
        token: urlParams.access_token || '',
        channelId: '',
        channelsList: []
      }
    };
  },

  componentWillMount: function () {
    SlackModalStore.listen(this._toggleModal);
  },

  componentDidMount: function () {
    if (this.state.slack.status === 'success') {
      $.ajax({
        url: '/api_slack/channels',
        dataType: 'JSON',
        method: 'GET',
        data: { token: this.state.slack.token },
        success: function (response) {
          if (response.data.working_channels) {
            var workingChannels = JSON.parse(response.data.working_channels);
            $.each(workingChannels, function(i, v){
              var channel = v;
              this.state.show = true;
              this.state.slack.channelsList.push(channel);
            });
            this.forceUpdate();
          }
        }.bind(this)
      });
    }
  },

  componentWillUnmount: function () {
    SlackModalStore.unlisten(this._toggleModal);
  },

  render: function() {
    if (this.state.show) {

      var slackSettings,
          slackIntegration,
          slackHref = location.protocol + '//' + location.host +
          '/api_slack/slack/authorize?project_id=' + this.props.projectId;

      slackIntegration = (
        <div>
          <h6>Slack Integration</h6>
          <p>Creates a new Arbor User Story from Slack.</p>
          <a href={slack_href}>
            <img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcSet="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" />
          </a>
        </div>
      );

      if (this.state.slack.status === 'success') {
        slackIntegration = null;
        slackSettings = (
          <div>
            <h6>Settings</h6>
            <p>Save settings for this project.</p>
            <select id='channel-id' name='slackChannelId' onChange = {this._handleChannelIdChange}>
              {
                this.state.slack.channelsList.map(function(channel, index) {
                  return <option key={index} value={channel.id}> {channel.name} </option>
                })
              }
            </select>
            <a type='submit' className='save-settings' onClick={this.handleSaveClick}>
              Save
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
