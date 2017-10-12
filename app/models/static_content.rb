class StaticContent < ApplicationRecord

    validates :slug, presence: true, uniqueness: true

    def to_param
        slug
    end
end
