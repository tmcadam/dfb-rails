# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview
    def admin_comment_email
        CommentMailer.admin_comment_email(Comment.last)
    end

    def comment_email
        CommentMailer.comment_email(Comment.last)
    end
end
