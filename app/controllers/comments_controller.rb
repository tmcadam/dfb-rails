class CommentsController < ApplicationController

    def create
        @comment = Comment.new( comment_params_public )
        @comment.approved = false
        respond_to do |format|
            if @comment.save
                format.json { render json: {'status': 'Success' }, status: :created }
            else
                format.json { render json: {'status': 'Errors', 'errors': @comment.errors}, status: :unprocessable_entity }
            end
        end
    end

private

    def comment_params_public
        params.require(:comment).permit(:biography_id, :name, :email, :comment)
    end

end
