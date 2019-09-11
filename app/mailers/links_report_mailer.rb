class LinksReportMailer < ApplicationMailer
    default from: "Falklands Biographies <webmaster@falklandsbiographies.org>"

    def links_report_email(fails, count)
        # Preview @ http://localhost:3000/rails/mailers/links_report_mailer/links_report_email
        @fails = fails
        @count = count
        mail(to: Rails.configuration.admin_comment_email, subject: 'Links report')
    end

end
