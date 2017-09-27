class Biography < ApplicationRecord
    validates :slug, presence: true, uniqueness: true
end
