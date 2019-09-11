require "test_helper"

class CommentMailerTest < ActionMailer::TestCase

    setup do
        @b = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
    end

    test "links_report_email" do
        # Create the email and store it for further assertions
        result = {count:3, fails:[{title:"Link2", url:"http://www.goog-ERROR-le.com", bio:@b }] }

        email = LinksReportMailer.links_report_email(result[:fails], result[:count])

        # Send the email, then test that it got queued
        assert_enqueued_emails 1 do
            email.deliver_later
        end

        # Test the body of the sent email contains what we expect it to
        assert_equal ['webmaster@falklandsbiographies.org'], email.from
        assert_equal ["test1@test.com", "test2@test.com"], email.to
        assert_equal 'Links report', email.subject
    end

    teardown do
      Image.destroy_all
      Comment.destroy_all
      Biography.destroy_all
    end
end
