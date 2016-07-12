function AnalyticsTracks() {}

AnalyticsTracks.createProject = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'Project',
                 eventAction: 'Create Project',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.openExampleProject = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'Project',
                 eventAction: 'Open Example Project',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.createUserStory = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'User Story',
                 eventAction: 'Create User Story',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.addUserStoryToProject = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'User Story',
                 eventAction: 'Add User Story to Project',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.inviteOutsider = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'Users',
                 eventAction: 'Invite User to Arbor',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.pdfExport = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'Export',
                 eventAction: 'Export to PDF',
                 eventLabel: 'Arbor Track' });
  }
};

AnalyticsTracks.trelloExport = function() {
  if (Environment.isProduction()) {
    ga('send', { hitType: 'event',
                 eventCategory: 'Export',
                 eventAction: 'Export to Trello',
                 eventLabel: 'Arbor Track' });
  }
};
