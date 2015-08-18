class MembersProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :member, class_name: User
end
