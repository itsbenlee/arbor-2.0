var ReleasePlan = React.createClass({
  propTypes: {
    project: React.PropTypes.object
  },

  render: function() {
    return (
      <table className='release-plan'>
        <thead>
          <tr className='release-plan-header'>
            <th className='sprint-title current-sprint'>Month</th>
            <th className='sprint-title'>Savings</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>January</td>
            <td>$100</td>
          </tr>
          <tr>
            <td>February</td>
            <td>$80</td>
          </tr>
        </tbody>
      </table>
    );
  }
});
