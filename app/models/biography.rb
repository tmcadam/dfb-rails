class Biography < ApplicationRecord
    has_many :images
    validates :slug, presence: true, uniqueness: true
    default_scope { order(title: :asc) }

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

private

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
        self.images.each do |image|
            pos_class = ApplicationController.helpers.cycle("biography-img-right", "biography-img-left", name: "pos_class" )
            img_tag = ApplicationController.helpers.image_tag image.image.url(:medium), class: pos_class
            tag = ApplicationController.helpers.link_to img_tag, image.image.url(:original), data: {toggle:'lightbox',
                                                                                                    gallery:'lightbox-gallery'}
            tags.push({"tag"=>tag, "after_para"=>after_para})
            after_para += 2
        end
        ApplicationController.helpers.reset_cycle("pos_class")
        tags
    end
end
