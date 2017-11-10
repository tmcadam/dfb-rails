class BiographyAuthor < ApplicationRecord
    belongs_to :biography
    belongs_to :author
end
