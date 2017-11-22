
module ApplicationHelper

    def clean_urls body
        hosts = [ "https://www.falklandsbiographies.org",
                  "https://falklandsbiographies.org",
                  "https://dfb.ukfit.webfactional.com",
                  "http://dfb-staging.ukfit.webfactional.com",
                  "http://0.0.0.0:3000"]
        body.gsub!(Regexp.union(hosts), "")
    end

end
