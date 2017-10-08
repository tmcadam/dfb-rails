class Biography < ApplicationRecord
    has_many :images
    validates :slug, presence: true, uniqueness: true
    default_scope { order(title: :asc) }

    def body_with_images
        paras = Nokogiri::HTML.parse(self.body).css('p')
        output = paras.slice(0,1).map {|x| x.to_html}.compact.join
        current_para = 1
        position = "right"
        self.images.each do |image|
            if position == "right"
                pos_class = "biography-img-right"
                position = "left"
            else
                pos_class = "biography-img-left"
                position = "right"
            end
            output += ActionController::Base.helpers.image_tag image.image.url(:medium), class: pos_class
            output += paras.slice(current_para,2).map {|x| x.to_html}.compact.join
            current_para += 2
        end
        output += paras.slice(current_para, paras.length).map {|x| x.to_html}.compact.join
    end
end
