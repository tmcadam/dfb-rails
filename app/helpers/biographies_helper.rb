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
          bio.gather_links.each do |link|
            if link[:url].start_with?('https://www.youtube.com')
              link[:youtube_url] = "https://www.youtube.com/oembed?url=" + link[:url] + "&format=json"
            end
            links << link
          end
        end
        links
    end

    def check_links_in_bios
      user_agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0"
      fails = Array.new
      hydra = Typhoeus::Hydra.new(max_concurrency: 20)
      links = gather_all_links
      links.each do |link|
        url = link.key?(:youtube_url) ? link[:youtube_url] : link[:url]
        request = Typhoeus::Request.new(url, method: :get, followlocation: true, timeout: 30, ssl_verifypeer: false, headers: {"User-Agent" => user_agent})
        request.on_complete do |response|
          if response.code == 0 or response.code > 308
            fails.push(link)
          end
        end
        request.on_body do |chunk|
            :abort
        end
        hydra.queue(request)
      end
      hydra.run
      {count:links.length, fails:fails}
    end

    def links_report
      links_result = check_links_in_bios
      LinksReportMailer.links_report_email(links_result[:fails], links_result[:count]).deliver_now
    end

end
