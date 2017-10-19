class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    protected
        def restrict_to_development
            raise ActionController::RoutingError.new('Not Found') unless Rails.env.development? or Rails.env.test?
        end

end
