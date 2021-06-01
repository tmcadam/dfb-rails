require 'test_helper'

class StaticContentControllerTest < ActionDispatch::IntegrationTest

    setup do
        @about = static_contents(:about)
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "helpers generate correct paths for static_content" do
        assert_equal static_content_path(@about), "/about"
    end

    test "can show static content using slug" do
        get static_content_path(@about) #uses one of the fixtures
        assert_response :success
    end

    test "404 if static_content slug not found" do
        assert_raises(ActiveRecord::RecordNotFound) {get static_content_path("slug_typo")}
    end

    test "can show static content at root urls not static_content urls" do
        get static_content_path(@about)
        assert_response :success
    end

    test "root url redirects to static_content home" do
        get "/"
        assert_response :redirect
        assert_redirected_to "/home"
    end

    # some route tests, should really be in a sepertae file

    test "home url is routed to home view" do
        assert_generates "/home", controller: "static_content", action: "home"
    end

    # end route tests

    test "home page displays 'featured bios' cards" do
        image4 = fixture_file_upload 'test_image_4.jpg', 'image/jpg'
        for x in 1..6 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
            Image.create(biography: @b, title:"Portrait2", caption:"Brian at work", image: image4)
        end
        get "/home"
        assert_select "div.card", 6
    end

    test "first bio image is displayed in featured card" do

        image1 = fixture_file_upload 'test_image_4.jpg', 'image/jpg' # portrait
        image2 = fixture_file_upload 'test_image_2.tif', 'image/tif' # landscape

        for x in 1..6 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
            if x == 1
                @i2 = Image.create( id: 2, biography: @b, title: "2", caption: "2", image: image2 )
                @i1 = Image.create( id: 1, biography: @b, title: "1", caption: "1", image: image1 )
            end
        end
        get "/home"
        assert_select "div.card:nth-child(1)" do
            assert_select "img" do
                assert_select "[src=?]", @i1.image.url(:medium)
            end
        end
    end

    test "about doesn't display 'featured bios' cards" do
        image4 = fixture_file_upload 'test_image_4.jpg', 'image/jpg'
        for x in 1..6 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
            Image.create(biography: @b, title:"Portrait2", caption:"Brian at work", image: image4)
        end
        get "/about"
        assert_select "div.card", 0
    end

    test "edit returns populated form, if logged in" do
        sign_in @u1
        get edit_static_content_path(@about)
        assert_response :success
        assert_select "input#static_content_title" do
             assert_select "[value=?]", "About"
        end
        assert_select "textarea#static_content_body", "<p>Some other body text</p>"
        assert_select "input#static_content_slug" do
             assert_select "[value=?]", "about"
        end
        assert_equal assigns(:static_content).title, @about.title
        assert_equal assigns(:static_content).body, @about.body
        assert_equal assigns(:static_content).slug, @about.slug
    end

    test "update, updates values if logged in and redirects" do
        sign_in @u1
        patch static_content_path(@about),  params: { static_content: { title: "true", body: "body", slug: "slug" } }
        @about.reload
        assert_equal "true", @about.title
        assert_equal "body", @about.body
        assert_equal "slug", @about.slug
        assert_redirected_to static_content_path(@about)
    end


    test "edit and update redirects if not logged in" do
        get edit_static_content_path(@about)
        assert_redirected_to new_user_session_path

        patch static_content_path(@about),  params: { static_content: { title: "true", body: "body", slug: "slug" } }
        assert_redirected_to new_user_session_path
    end

    test "renders 'Edit','Delete' buttons and 'New' menu if logged in" do
        sign_in @u1
        get static_content_path(@about)
        assert_select "a.btn[href=?]", edit_static_content_path(@about), {:text => "Edit"}
        assert_select "a.btn[href=?]", static_content_path(@about), {:text => "Delete", :method => :DELETE}
        assert_select "a[href=?]", new_static_content_path
    end

    test "doesn't render edit button if not logged in" do
        get static_content_path(@about)
        assert_select "a.btn", false, {:text => "Edit"}
        assert_select "a.btn", false, {:text => "Delete"}
        assert_select "a[href=?]", new_static_content_path, false
    end

    test "can render a create new static_content form, if logged in" do
        sign_in @u1
        get new_static_content_path
        assert_response :success
        assert_select "input#static_content_title"
        assert_select "input#static_content_slug"
        assert_select "textarea#static_content_body"
        assert_select "input#static_content_title[value]", false
        assert_select "input#static_content_slug[value]", false
        assert_select "textarea#static_content_body[value]", false
    end

    test "can not render new static content form if not logged in" do
        get new_static_content_path
        assert_redirected_to new_user_session_path
    end

    test "can create new static page if logged in" do
        sign_in @u1
        assert_difference('StaticContent.count') do
            post static_content_index_path(static_content:{title:"New page", slug:"new_page", body:"A great page"})
        end
        assert_redirected_to static_content_path("new_page")
    end

    test "can not create new static content if not logged in" do
        assert_no_difference('StaticContent.count') do
            post static_content_index_path(static_content:{title:"New page", slug:"new_page", body:"A great page"})
        end
        assert_redirected_to new_user_session_path
    end

    test "can destroy static_content if logged in" do
        sign_in @u1
        @sc = StaticContent.create(title:"New page", slug:"new_page", body:"A great page")
        assert_difference('StaticContent.count', -1) do
            delete static_content_path(@sc)
        end
        assert_redirected_to static_content_path("home")
    end

    test "can not delete if not logged in" do
        @sc = StaticContent.create(title:"New page", slug:"new_page", body:"A great page")
        assert_no_difference('StaticContent.count') do
            delete static_content_path(@sc)
        end
        assert_redirected_to new_user_session_path
    end

    test "Correct view rendered for /home" do
        get "/home"
        assert_select "h1.jumbotron-heading", 1
        assert_select "h3.page-title", 0
    end

    test "Correct view rendered for other static pages" do 
        get "/about"
        assert_select "h1.jumbotron-heading", 0
        assert_select "h3.page-title", 1
    end

    teardown do
        DatabaseCleaner.clean
    end

end
