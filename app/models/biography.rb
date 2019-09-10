require 'rest-client'

class Biography < ApplicationRecord
    include ApplicationHelper
    has_many :images
    has_many :comments
    validates :slug, presence: true, uniqueness: true
    validates :title, presence: true
    validates :body, presence: true
    default_scope { order(title: :asc) }
    before_save :clean_bio_urls
    before_save :clean_bio_html

    has_many :biography_authors
    accepts_nested_attributes_for :biography_authors, reject_if: :all_blank, allow_destroy: true

    #has_many :authors, :through => :biography_authors

    belongs_to :primary_country, foreign_key: :primary_country_id, class_name:"Country", optional: true
    belongs_to :secondary_country, foreign_key: :secondary_country_id, class_name:"Country", optional: true

    def approved_comments
       comments.where(approved: true).order(:created_at)
    end

    def body_with_images
        output = ""
        images = generate_image_tags
        p_counter = 0
        get_body_elements.each do |element, index|
            output += element.to_html
            if element.text.length > 200
                p_counter += 1
                output += insert_image(p_counter, images)
            end
        end
        output
    end

    def has_single_author
        biography_authors.length <= 1 ? true : false
    end

    def other_author (author)
        if not has_single_author
            biography_authors.where.not(author_id: author.id).first.author
        end
    end

private

    def clean_bio_urls
        clean_urls(self.body)
    end

    def clean_bio_html
        self.body = clean_html(self.body)
    end

    def insert_image(p, images)
        images.each do |img|
            if img["after_para"] == p
                return img["tag"]
            end
        end
        return String.new
    end

    def get_body_elements
        Nokogiri::HTML::fragment(self.body).children
    end

    def generate_image_tags
        tags = []
        after_para = 1
        self.images.order(:id).each do |image|
            pos_class = ApplicationController.helpers.cycle("biography-img-right", "biography-img-left", name: "pos_class" )
            tag = ApplicationController.render(partial: 'images/tag', assigns: {img: image, class: pos_class})
            tags.push({"tag"=>tag, "after_para"=>after_para})
            after_para += 2
        end
        ApplicationController.helpers.reset_cycle("pos_class")
        tags
    end

    def check_links
        page = Nokogiri::HTML::fragment(self.external_links).children
        links = page.css('a')
        fails = Array.new
        links.each do |link|
            begin
              response = RestClient.get link['href']
            rescue
              fails.push({title: link.inner_html, url: link['href']})
            end
        end
        {  count: links.length, fails: fails}
    end

end
