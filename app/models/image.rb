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
    before_save :populate_dims

    def orientation
        ratio = self.dim_x.to_f / self.dim_y.to_f
        if ratio > 0.6 and ratio < 1.4   
            "square"
        elsif ratio >= 1.4
            "landsacpe"
        else
            "portrait"
        end
    end

private

    def clean_image_urls
      clean_urls(self.caption)
    end

    def populate_dims
        if self.image.queued_for_write[:original] != nil
            path = self.image.queued_for_write[:original].path
        else
            path = self.image.path(:original)
        end
        
        if File.file?(path)
            dimensions = Paperclip::Geometry.from_file(path)
            self.dim_x = dimensions.width
            self.dim_y = dimensions.height
        else
            puts "MISSING: %s" % path
        end 
    end

end
