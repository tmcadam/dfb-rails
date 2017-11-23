class StaticContentController < ApplicationController
    before_action :authenticate_user!, :only => [:edit, :update, :new, :create, :destroy]

    def show
        @static_content = StaticContent.find_by!(slug: params[:slug])
    end

    def new
        @static_content = StaticContent.new
    end

    def create
        @static_content = StaticContent.new( static_content_params )
        if @static_content.save
            redirect_to static_content_path(@static_content)
        else
            render 'new'
        end
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

    def destroy
        @static_content = StaticContent.find_by!(slug: params[:slug])
        @static_content.destroy
        redirect_to static_content_path("home")
    end

private

    def static_content_params
        params.require(:static_content).permit(:title, :slug, :body)
    end

end
