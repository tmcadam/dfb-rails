class StaticContent < ApplicationRecord
    include ApplicationHelper
    validates :slug, presence: true, uniqueness: true
    before_save :clean_static_content_urls

    def to_param
        slug
    end

private

    def clean_static_content_urls
        clean_urls(self.body)
    end

end
