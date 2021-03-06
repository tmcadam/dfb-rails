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

    def parse_links (links)
        parsed_links = Array.new
        links.each do |link|
          parsed_links.push({title: link.inner_html, url: link['href'], bio: self})
        end
        parsed_links
    end


    def gather_links
        links = Nokogiri::HTML::fragment(self.external_links).children.css('a')
        links += Nokogiri::HTML::fragment(self.references).children.css('a')
        parse_links(links)
    end

private

    def clean_bio_urls
        clean_urls(self.body)
    end

    def clean_bio_html
        self.body = clean_html(self.body)
        self.references = clean_html(self.references)
        self.external_links = clean_html(self.external_links)
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
        class_left = "float-sm-left mr-sm-3"
        class_right = "float-sm-right ml-sm-3"
        self.images.order(:id).each do |image|
            pos_class = ApplicationController.helpers.cycle(class_right, class_left, name: "pos_class" )
            tag = ApplicationController.render(partial: 'images/tag', assigns: {img: image, class: pos_class})
            tags.push({"tag"=>tag, "after_para"=>after_para})
            after_para += 2
        end
        ApplicationController.helpers.reset_cycle("pos_class")
        tags
    end

end
