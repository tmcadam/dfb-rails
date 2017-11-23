class Image < ApplicationRecord
    include ApplicationHelper
    belongs_to :biography
    has_attached_file :image,
                    styles: {  thumb: ["100x100>", :jpg],
                               medium: ["300x300>", :jpg],
                               original: ["800x800>", :jpg]
                           },
                    default_url: "/images/:style/missing.png",
                    url: "/system/biography_images/:style/:filename",
                    path: ":rails_root/public/system/biography_images/:style/:filename"

    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    validates_attachment_presence :image
    validates :title, presence: true
    validates :caption, presence: true
    before_save :clean_image_urls

private

    def clean_image_urls
      clean_urls(self.caption)
    end

end
