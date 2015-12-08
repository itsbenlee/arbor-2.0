class FixActivitiesWithCorrectArticles < ActiveRecord::Migration
  def data
    UserStory.all.each do |user_story|
      user_story.activities.all.each do |activity|
        value = activity.value
        begin
          if (value.index('I').present?)
            if (value.index('a/an').present?)
              subject = value["As a/an ".length..value.index("I")-1]
              article = subject.indefinite_article
              activity.value = value.gsub("As a/an #{subject}", "As #{article} #{subject}")
              activity.save
            else
              subject = value["As a ".length..value.index("I")-1]
              article = subject.indefinite_article
              activity.value = value.gsub("As a #{subject}", "As #{article} #{subject}")
              activity.save
            end
          end
        rescue => e
          logger.warn "Unable to fix article for log line: #{e}"
        end
      end
    end
  end
end
