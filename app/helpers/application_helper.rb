
module ApplicationHelper

    def clean_urls body
        hosts = [ "https://www.falklandsbiographies.org",
                  "https://falklandsbiographies.org",
                  "https://dfb.ukfit.webfactional.com",
                  "http://dfb-staging.ukfit.webfactional.com",
                  "http://0.0.0.0:3000"]
        body.gsub!(Regexp.union(hosts), "")
    end

    def clean_html body
        scrubber = Loofah::Scrubber.new do |node|
          node.remove if node.text.squish == ""
        end
        body = ActionController::Base.helpers.sanitize(body)
        ActionController::Base.helpers.sanitize(body, scrubber: scrubber)
    end

end
