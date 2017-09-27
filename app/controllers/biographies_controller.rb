class BiographiesController < ApplicationController

    def show
        @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
    end

    def index
        @biographies = if params[:search]
            Biography.where('title LIKE ?', "%#{params[:search]}%")
        else
            Biography.all
        end
    end

end
