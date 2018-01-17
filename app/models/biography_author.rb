class BiographyAuthor < ApplicationRecord
    belongs_to :biography, autosave: true
    belongs_to :author
    validates :author_id, presence: true
    validates :biography_id, presence: true
    validates :author_position, presence: true
    validates_uniqueness_of :biography_id, :scope => [:author_id]
    validates_uniqueness_of :author_position, :scope => [:biography_id]
    default_scope { order(author_position: :asc) }

end
