class Author < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :biography_authors
    has_many :biographys, :through => :biography_authors
end
