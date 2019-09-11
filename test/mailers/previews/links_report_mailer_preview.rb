# Preview all emails at http://localhost:3000/rails/mailers/links_report_mailer/links_report_email
class LinksReportMailerPreview < ActionMailer::Preview
    def links_report_email
        @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
        result = {count:3, fails:[{title:"Link2", url:"http://www.goog-ERROR-le.com", bio:@b2 }] }
        LinksReportMailer.links_report_email(result[:fails], result[:count])
    end
end
