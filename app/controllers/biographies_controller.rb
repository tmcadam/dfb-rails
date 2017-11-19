class BiographiesController < ApplicationController
    include BiographiesHelper
    before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :reset_featured]

    def show
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
    end

    def index
        @biographies = if params[:search]
            Biography.where('title ILIKE ?', "%#{params[:search]}%").page params[:page]
        else
            Biography.all.page params[:page]
        end
    end

    def new
        @biography = Biography.new
    end

    def create
        @biography = Biography.new( biography_params )
        if @biography.save
            redirect_to @biography
        else
            render 'new'
        end
    end

    def edit
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
    end

    def update
        @biography = Biography.find(params[:id])
        if @biography.update( biography_params )
            redirect_to @biography
        else
            render 'edit'
        end
    end

    def destroy
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
        @biography.destroy
        redirect_to biographies_path
    end

    def reset_featured
        reset_featured_bios
        redirect_to "/home", :flash => { :notice => "Featured biographies reset successful" }
    end

    private

        def biography_params
            params.require(:biography).permit(:title, :body, :slug, :authors, :lifespan, :revisions, :primary_country_id, :secondary_country_id, :south_georgia, :featured)
        end

end
