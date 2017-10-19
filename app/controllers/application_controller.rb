class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    protected
        def restrict_to_development
            head(:bad_request) unless Rails.env.development? or Rails.env.test?
        end

end
