class ApiKey < ActiveRecord::Base
  before_create :generate_access_token
  belongs_to :user
  validates_uniqueness_of :access_token

  private

  def generate_access_token
    loop do
      self.access_token = SecureRandom.hex
      break unless self.class.exists?(access_token: access_token)
    end
  end
end
