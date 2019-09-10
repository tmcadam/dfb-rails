module BiographiesHelper

    def clear_featured
        Biography.update_all featured: false
    end

    def with_images(bios)
        bios.unscoped.joins(:images).distinct
    end

    def with_lifespan_author(bios)
        bios.where("lifespan IS NOT NULL").where("authors IS NOT NULL")
    end

    def get_random_ids(bios)
        bios.pluck(:id).sample(3)
    end

    def get_features(ids)
        Biography.where(id: ids)
    end

    def set_featured(bios)
        bios.update_all featured: true
    end

    def reset_featured_bios
        Biography.update_all featured: false
        bios = with_images(Biography.all)
        bios = with_lifespan_author(bios)
        bios_ids = get_random_ids(bios)
        bios = get_features(bios_ids)
        set_featured(bios)
    end

    def gather_all_links
        links = Array.new
        Biography.all.each do |bio|
             links += bio.gather_links
        end
        links
    end

end
