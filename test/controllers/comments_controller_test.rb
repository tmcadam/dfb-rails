require 'test_helper'

class CommentControllerTest < ActionDispatch::IntegrationTest

    setup do
        @b = Biography.create(title: "Brian Black", slug: "brian_black", body: "Some body")
    end

    test "new comment created if correct parameters submitted and approved is false" do
        assert_difference('Comment.count', 1) do
            post comments_path( comment: {
                biography_id: @b.id,
                name:"Joe",
                email:"email@email.com",
                comment:"A great page" }), xhr: true
        end
        assert_equal Comment.last.approved, false
        assert_equal 201, @response.status
        json = ActiveSupport::JSON.decode @response.body
        assert_equal 'Success', json['status']
    end

    test "comment not created if paprameters incorrect" do
        assert_difference('Comment.count', 0) do
            post comments_path( comment: {
                biography_id: @b.id,
                name:"Joe",
                email:"not an email",
                comment:"A great page" }), xhr: true
        end
        assert_equal 422, @response.status
        json = ActiveSupport::JSON.decode @response.body
        assert_equal 'Errors', json['status']
        assert json['errors']['email'][0].include? "is not a valid email"
    end

    teardown do
        DatabaseCleaner.clean
    end

end
