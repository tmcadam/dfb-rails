class StaticContent < ApplicationRecord
    validates :slug, presence: true, uniqueness: true
end
