class BiographiesController < ApplicationController
    include BiographiesHelper
    before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :reset_featured, :check_links]

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
        begin
            if @biography.save
                redirect_to biography_path(@biography.slug)
            else
                render 'new'
            end
        rescue ActiveRecord::RecordNotUnique
            @biography.errors.add(:base,'Attributed author and author position must be unique.')
            render 'new'
        end
    end

    def edit
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
    end

    def update
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
        @biography.assign_attributes(biography_params)
        begin
            if @biography.save
                redirect_to biography_path(@biography.slug)
            else
                render 'edit'
            end
        rescue ActiveRecord::RecordNotUnique
            @biography.errors.add(:base,'Attributed author and author position must be unique.')
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

    def check_links
        links_result = check_links_in_bios
        @fails = links_result[:fails]
        @count = links_result[:count]
    end

    private

        def biography_params
            params.require(:biography).permit(:title, :body, :slug, :authors, :lifespan,
                                                :revisions, :primary_country_id, :secondary_country_id, :south_georgia, :featured,
                                                :external_links, :references,
                                                biography_authors_attributes: [:id, :author_position, :author_id, :_destroy ])
        end

end
