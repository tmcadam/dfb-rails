class Author < ApplicationRecord
    validates :last_name, presence: true, uniqueness: {scope: :first_name}
    has_many :biography_authors, :dependent => :destroy
    has_many :biographys, :through => :biography_authors
    default_scope { order(last_name: :asc, first_name: :asc) }

    def name
        first_name ? "#{first_name} #{last_name}" : last_name
    end

    def simple_slug
        name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end

end
