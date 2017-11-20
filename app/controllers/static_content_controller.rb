class StaticContentController < ApplicationController
    before_action :authenticate_user!, :only => [:edit, :update]

    def show
        @static_content = StaticContent.find_by!(slug: params[:slug])
    end

    def edit
        @static_content = StaticContent.find_by!(slug: params[:slug])
    end

    def update
        @static_content = StaticContent.find_by!(slug: params[:slug])
        if @static_content.update( static_content_params )
            redirect_to @static_content
        else
            render 'edit'
        end
    end

    private

        def static_content_params
            params.require(:static_content).permit(:title, :slug, :body)
        end

end
