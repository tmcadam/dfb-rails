require 'test_helper'

class CommentControllerTest < ActionDispatch::IntegrationTest

    setup do
        DatabaseCleaner.clean
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
        @b = Biography.create(title: "Brian Black", slug: "brian_black", body: "Some body")
        @c1 = Comment.create(biography: @b, name: "Tom", email: "blah@blah.com", comment: "Some comment", approved: false, approve_key: "some-test-key" )
    end

    test "can approve comment with approve_key if not logged in" do
        assert_not @c1.approved
        get '/comments/approve/some-test-key'
        @c1.reload
        assert @c1.approved
        assert_not @c1.approve_key
        assert_redirected_to biography_path(@b)
    end
    test "can approve comment with approve_key if logged in" do
        sign_in @u1
        assert_not @c1.approved
        get '/comments/approve/some-test-key'
        @c1.reload
        assert @c1.approved
        assert_not @c1.approve_key
        assert_redirected_to biography_path(@b)
    end

    test "can not approve comment if incorrect key" do
        assert_not @c1.approved
        get '/comments/approve/some-wrong-test-key'
        @c1.reload
        assert_not @c1.approved
        assert @c1.approve_key
        assert_redirected_to "/home"
    end

    test "can not approve comment with nil approve_key" do
        @c1.approve_key = nil
        assert_not @c1.approved

        get '/comments/approve/'
        @c1.reload
        assert_not @c1.approved
        assert_redirected_to "/home"

        get '/comments/approve/some-key'
        @c1.reload
        assert_not @c1.approved
        assert_redirected_to "/home"
    end

    test "can show comments index if logged in" do
        sign_in @u1
        get comments_path
        assert_response :success
    end

    test "can not see comments index if not logged in" do
        get comments_path
        assert_redirected_to new_user_session_path
    end

    test "can delete comment if logged in" do
        sign_in @u1
        assert_difference('Comment.count', -1) do
            delete comment_path(@c1)
        end
        assert_redirected_to comments_path
    end

    test "cannot delete comment if not logged in" do
        assert_no_difference 'Comment.count' do
            delete comment_path(@c1)
        end
        assert_redirected_to new_user_session_path
    end

    test "can update comment to approved if logged in" do
        sign_in @u1
        patch comment_url(@c1), params: { comment: { approved: true } }
        assert_redirected_to comments_path
        @c1.reload
        assert @c1.approved
    end

    test "cannot approve comment if not logged in" do
        patch comment_url(@c1), params: { comment: { approved: true } }
        assert_redirected_to new_user_session_path
        @c1.reload
        assert_not @c1.approved
    end

    test "edit form renders populated form if logged in" do
        sign_in @u1
        get edit_comment_path(@c1)
        assert_response :success
        assert_select "form#edit_comment_#{@c1.id}"
        assert_select 'select#comment_biography_id option[selected]', @b.title
        assert_select 'input#comment_name[value=?]', @c1.name
        assert_select 'input#comment_email[value=?]', @c1.email
        assert_select 'textarea#comment_comment', { text: @c1.comment }
        assert_select 'input[name="comment[approved]"][value=?]', if @c1.approved then "1" else "0" end
    end

    test "cannot view edit form if not logged in" do
        get edit_comment_path(@c1)
        assert_redirected_to new_user_session_path
    end

    test "new comment created if correct parameters submitted and approved set to false" do
        assert_difference('Comment.count', 1) do
            post comments_path( url: "",
                comment: {
                biography_id: @b.id,
                name:"Joe",
                email:"email@email.com",
                comment:"A great page" }), xhr: true
        end
        assert_enqueued_emails 2
        assert_equal Comment.last.approved, false
        assert_not_nil Comment.last.approve_key
        assert Comment.last.approve_key.length > 16
        assert_equal 201, @response.status
        json = ActiveSupport::JSON.decode @response.body
        assert_equal 'Success', json['status']
    end

    test "comment not created if paprameters incorrect" do
        assert_difference('Comment.count', 0) do
            post comments_path( url: "",
                comment: {
                biography_id: @b.id,
                name:"Joe",
                email:"not an email",
                comment:"A great page" }), xhr: true
        end
        assert_no_enqueued_emails
        assert_equal 422, @response.status
        json = ActiveSupport::JSON.decode @response.body
        assert_equal 'Errors', json['status']
        assert json['errors']['email'][0].include? "is not a valid email"
    end

    test "comment not created if spam parameters detected" do
        assert_difference('Comment.count', 0) do
            post comments_path( url: "some spam bot did this",
                comment: {
                biography_id: @b.id,
                name:"Joe",
                email:"not an email",
                comment:"A great page" }), xhr: true
        end
        assert_no_enqueued_emails
        assert_equal 201, @response.status
        json = ActiveSupport::JSON.decode @response.body
        assert_equal 'Success - extra', json['status']
    end

    teardown do
        DatabaseCleaner.clean
    end

end
