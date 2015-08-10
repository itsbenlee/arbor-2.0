class User < ActiveRecord::Base
  validates_presence_of :full_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
