class Country < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :biographies, foreign_key: :primary_country_id
    default_scope { order(name: :asc) }
end
