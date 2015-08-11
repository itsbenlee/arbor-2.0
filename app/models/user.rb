class User < ActiveRecord::Base
  validates_presence_of :full_name
  validates_presence_of :email
  validates_uniqueness_of :email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
