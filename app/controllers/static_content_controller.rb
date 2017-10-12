class StaticContentController < ApplicationController
    def show
        @static_content = StaticContent.find_by!(slug: params[:slug])
    end
end
