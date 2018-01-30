class Comment < ApplicationRecord
  belongs_to :biography
  validates :name, presence: true
  validates :email, presence: true
  validates :comment, presence: true
end
