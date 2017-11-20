require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "can show authors index" do
        get authors_path
        assert_response :success
    end

    test "new, edit, delete buttons present if logged in" do
        sign_in @u1
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        @a = Author.create(last_name:"JONES", first_name:"James", biography:"A great guy")
        get authors_path
        assert_select "a.btn", "New", 1
        assert_select "a.btn", "Edit", 2
        assert_select "a.btn", "Delete", 2
    end

    test "no new, edit, delete buttons present if not logged in" do
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        @a = Author.create(last_name:"JONES", first_name:"James", biography:"A great guy")
        get authors_path
        assert_select "a.btn", false
    end

    test "can render a create new authors form, if logged in" do
        sign_in @u1
        get new_author_path
        assert_response :success
        assert_select "input#author_last_name[value]", false
        assert_select "input#author_first_name[value]", false
        assert_select "textarea#author_biography[value]", false
    end

    test "can not render new form if not logged in" do
        get new_author_path
        assert_redirected_to new_user_session_path
    end

    test "can create a new author through using new form, and redirected to authors" do
        sign_in @u1
        assert_difference('Author.count') do
            post authors_path(author:{last_name:"JONES", first_name:"Bob", biography:"A great guy"})
        end
        assert_redirected_to authors_path + "#bob-jones"
    end

    test "can not create author if not looged in" do
        post authors_path(author:{last_name:"JONES", first_name:"Bob", biography:"A great guy"})
        assert_redirected_to new_user_session_path
    end

    test "can get update author form if logged in" do
        sign_in @u1
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        get edit_author_path(@a)
        assert_response :success
        assert_select "input#author_last_name[value='JONES']"
        assert_select "input#author_first_name[value='Bob']"
        assert_select "textarea#author_biography", "A great guy"
    end

    test "can not get update author form if not logged in" do
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        get edit_author_path(@a)
        assert_redirected_to new_user_session_path
    end

    test "can update author using update author for if logged in" do
        sign_in @u1
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        patch author_path(@a), params: {author:{last_name:"JENKINS", first_name:"Mike", biography:"Not a great guy"}}
        @a.reload
        assert_equal "JENKINS", @a.last_name
        assert_equal "Mike", @a.first_name
        assert_equal "Not a great guy", @a.biography
        assert_redirected_to authors_path + "#mike-jenkins"
    end

    test "can not update author if not logged in" do
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        patch author_path(@a), params: {author:{last_name:"JENKINS", first_name:"Mike", biography:"Not a great guy"}}
        assert_redirected_to new_user_session_path
    end

    test "can destroy author if logged in" do
        sign_in @u1
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        assert_difference('Author.count', -1) do
            delete author_path(@a)
        end
        assert_redirected_to authors_path
    end

    test "can not delete if not logged in" do
        @a = Author.create(last_name:"JONES", first_name:"Bob", biography:"A great guy")
        assert_no_difference('Author.count') do
            delete author_path(@a)
        end
        assert_redirected_to new_user_session_path
    end

    teardown do
        DatabaseCleaner.clean
    end
end
