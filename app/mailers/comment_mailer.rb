class CommentMailer < ApplicationMailer
    default from: "Falklands Biographies <webmaster@falklandsbiographies.org>"

    def comment_email(comment)
        # Preview @ http://localhost:3000/rails/mailers/comment_mailer/comment_email
        @comment = comment
        mail(to: @comment.email, subject: 'New comment recieved', from: "Falklands Biographies <webeditor@falklandsbiographies.org>" )
    end

    def admin_comment_email(comment)
        # Preview @ http://localhost:3000/rails/mailers/comment_mailer/admin_comment_email
        @comment = comment
        mail(to: Rails.configuration.admin_comment_email, subject: 'New comment recieved')
    end

end
