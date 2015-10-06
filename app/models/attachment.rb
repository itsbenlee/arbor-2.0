class Attachment < ActiveRecord::Base
  self.inheritance_column = :table_type

  validates_presence_of :content

  belongs_to :project
  belongs_to :user

  delegate :full_name, to: :user, prefix: true

  def type
    self.class.name.to_s.gsub('Attachment', '').downcase
  end
end
