class BiographiesController < ApplicationController
    def show
      @biography = Biography.find_by(slug: params[:id]) || Biography.find(params[:id])
    end
end
