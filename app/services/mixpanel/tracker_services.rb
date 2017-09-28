module Mixpanel
  class TrackerServices
    def track_event(user_id, event_name)
      return if ENV.fetch('MIXPANEL_PROJECT_TOKEN', '').empty?
      tracker.track(user_id, event_name)
    end

    private

    def tracker
      @tracker ||= Mixpanel::Tracker.new(ENV['MIXPANEL_PROJECT_TOKEN'])
    end
  end
end
