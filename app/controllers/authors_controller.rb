class AuthorsController < ApplicationController
    before_action :authenticate_user!, except:[:index]

    def index
        @authors = Author.all
    end

    def new
        @author = Author.new
    end

    def create
        @author = Author.new( author_params )
        if @author.save
            redirect_to authors_path + "##{@author.simple_slug}"
        else
            render 'new'
        end
    end

    def edit
        @author = Author.find( params[:id] )
    end

    def update
        @author = Author.find( params[:id] )
        if @author.update( author_params )
            redirect_to authors_path + "##{@author.simple_slug}"
        else
            render 'edit'
        end
    end

    def destroy
        @author = Author.find( params[:id] )
        @author.destroy
        redirect_to authors_path
    end

private

    def author_params
        params.require(:author).permit(:biography, :last_name, :first_name)
    end

end
