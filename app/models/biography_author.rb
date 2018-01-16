class BiographyAuthor < ApplicationRecord
    belongs_to :biography, autosave: true
    belongs_to :author
end
