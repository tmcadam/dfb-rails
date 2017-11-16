class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :store_user_location!, if: :storable_location?

    protected
        def restrict_to_development
            raise ActionController::RoutingError.new('Not Found') unless Rails.env.development? or Rails.env.test?
        end

        def storable_location?
            request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
        end

        def store_user_location!
            # :user is the scope we are authenticating
            store_location_for(:user, request.fullpath)
        end

end
