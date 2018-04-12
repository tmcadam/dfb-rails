require "test_helper"

class CommentMailerTest < ActionMailer::TestCase

    setup do
        @b = biographies(:three)
        @b.save
        @c1 = Comment.create(biography: @b, name: "Tom", email: "blah@blah.com", comment: "Some comment", approved: false)
    end

    test "comment_email" do
        # Create the email and store it for further assertions
        email = CommentMailer.comment_email(@c1)

        # Send the email, then test that it got queued
        assert_enqueued_emails 1 do
            email.deliver_later
        end

        # Test the body of the sent email contains what we expect it to
        assert_equal ['webeditor@falklandsbiographies.org'], email.from
        assert_equal ['blah@blah.com'], email.to
        assert_equal 'New comment received', email.subject
    end

    test "admin_comment_email" do
        # Create the email and store it for further assertions
        email = CommentMailer.admin_comment_email(@c1)

        # Send the email, then test that it got queued
        assert_enqueued_emails 1 do
            email.deliver_later
        end

        # Test the body of the sent email contains what we expect it to
        assert_equal ['webmaster@falklandsbiographies.org'], email.from
        assert_equal ['test@test.com'], email.to
        assert_equal 'New comment received', email.subject
    end

    teardown do
      DatabaseCleaner.clean
    end
end
