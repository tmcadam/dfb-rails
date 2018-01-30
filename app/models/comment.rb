class Comment < ApplicationRecord
  belongs_to :biography
  validates :name, presence: true
  validates :email, presence: true, :email_format => { :message => 'is not a valid email' }
  validates :comment, presence: true
end
