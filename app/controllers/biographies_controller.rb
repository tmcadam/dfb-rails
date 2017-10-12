class BiographiesController < ApplicationController

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

end
