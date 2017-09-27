class Biography < ApplicationRecord
    validates :slug, presence: true, uniqueness: true
    default_scope { order(title: :asc) }
end
