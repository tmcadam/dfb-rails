require 'securerandom'
class CommentsController < ApplicationController

    before_action :authenticate_user!, :only => [:index, :edit, :update, :destroy]

    def index
        @comments = Comment.all.order(:created_at).reverse_order.page params[:page]
    end

    def edit
        @comment = Comment.find( params[:id] )
    end

    def destroy
        @comment = Comment.find( params[:id] )
        @comment.destroy
        redirect_to comments_path, :flash => { :notice => "Comment successfully deleted." }
    end

    def update
        @comment = Comment.find( params[:id] )
        if @comment.update( comment_params )
            redirect_to comments_path, :flash => { :notice => "Comment successfully updated." }
        else
            render 'edit'
        end
    end

    def approve
        @comment = Comment.find_by(approve_key: params[:approve_key])
        if @comment && @comment.approve_key
            if @comment.update(approved: true, approve_key: nil)
                redirect_to "/home", :flash => { :notice => "Comment successfully approved." }
            end
        else
            redirect_to "/home", :flash => { :alert => "Comment update link was invalid." }
        end
    end

    def create
        respond_to do |format|
            if params[:url] == ""
                @comment = Comment.new( comment_params_public )
                @comment.approved = false
                @comment.approve_key = generate_approve_key
                if @comment.save
                    format.json { render json: {'status': 'Success' }, status: :created }
                    CommentMailer.comment_email(@comment).deliver_later
                    CommentMailer.admin_comment_email(@comment).deliver_later
                else
                    format.json { render json: {'status': 'Errors', 'errors': @comment.errors}, status: :unprocessable_entity }
                end
            else
                # A dummy success response for spambots
                format.json { render json: {'status': 'Success - extra' }, status: :created }
            end
        end
    end

private

    def generate_approve_key
        SecureRandom.urlsafe_base64(16)
    end

    def comment_params_public
        params.require(:comment).permit(:biography_id, :name, :email, :comment)
    end

    def comment_params
        params.require(:comment).permit(:biography_id, :name, :email, :comment, :approved)
    end

end
