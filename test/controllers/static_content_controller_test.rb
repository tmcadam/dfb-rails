require 'test_helper'

class StaticContentControllerTest < ActionDispatch::IntegrationTest

    setup do
        @home = static_contents(:home)
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "helpers generate correct paths for static_content" do
        assert_equal static_content_path(@home), "/home"
    end

    test "can show static content using slug" do
        get static_content_path(@home) #uses one of the fixtures
        assert_response :success
    end

    test "404 if static_content slug not found" do
        assert_raises(ActiveRecord::RecordNotFound) {get static_content_path("slug_typo")}
    end

    test "can show static content at root urls not static_content urls" do
        get static_content_path(@home)
        assert_response :success
    end

    test "root url redirects to static_content home" do
        get "/"
        assert_response :redirect
        assert_redirected_to static_content_path(@home)
    end

    test "home page displays 'featured bios' wells" do
        for x in 1..10 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
        end
        get "/home"
        assert_select "div.well", 3
    end

    test "about doesn't display 'featured bios' wells" do
        for x in 1..10 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
        end
        get "/about"
        assert_select "div.well", 0
    end

    test "edit returns populated form, if logged in" do
        sign_in @u1
        get edit_static_content_path(@home)
        assert_response :success
        assert_select "input#static_content_title" do
             assert_select "[value=?]", "Home"
        end
        assert_select "textarea#static_content_body", "<p>Some body text</p>"
        assert_select "input#static_content_slug" do
             assert_select "[value=?]", "home"
        end
        assert_equal assigns(:static_content).title, @home.title
        assert_equal assigns(:static_content).body, @home.body
        assert_equal assigns(:static_content).slug, @home.slug
    end

    test "update, updates values if logged in and redirects" do
        sign_in @u1
        patch static_content_path(@home),  params: { static_content: { title: "true", body: "body", slug: "slug" } }
        @home.reload
        assert_equal "true", @home.title
        assert_equal "body", @home.body
        assert_equal "slug", @home.slug
        assert_redirected_to static_content_path(@home)
    end


    test "edit and update redirects if not logged in" do
        get edit_static_content_path(@home)
        assert_redirected_to new_user_session_path

        patch static_content_path(@home),  params: { static_content: { title: "true", body: "body", slug: "slug" } }
        assert_redirected_to new_user_session_path
    end

    test "renders 'Edit' button if logged in" do
        sign_in @u1
        get static_content_path(@home)
        assert_select "a.btn[href=?]", edit_static_content_path(@home), {:text => "Edit"}
    end

    test "doesn't render edit button if not logged in" do
        get static_content_path(@home)
        assert_select "a.btn", false, {:text => "Edit"}
    end

    teardown do
        DatabaseCleaner.clean
    end

end
