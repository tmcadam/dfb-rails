require 'test_helper'

class BiographiesControllerTest < ActionDispatch::IntegrationTest

    setup do
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "can show biography using id" do
        get biography_path(1) # uses one of the fixtures
        assert_response :success
    end

    test "can show biography using slug" do
        get biography_path("slug_name1") #uses one of the fixtures
        assert_response :success
    end

    test "404 if biography id or slug not found" do
        assert_raises(ActiveRecord::RecordNotFound) {get biography_path(300)}
        assert_raises(ActiveRecord::RecordNotFound) {get biography_path("slug_typo")}
    end

    test "can show biographies index" do
        get biographies_path
        assert_response :success
    end

    test "index route returns all biographies" do
        get biographies_path
        biographies = @controller.index
        assert_equal(Biography.count, biographies.length)
        assert_select 'table#index' do
            assert_select 'tr', Biography.count
        end
    end

    test "search returns correct biograhies" do
        get biographies_path(:search=>"TITLE1")
        biographies = @controller.index
        assert_equal(1, biographies.length)
        assert_select 'table#index' do
            assert_select 'tr', 1
        end
        assert_equal(biographies[0].title, "TITLE1")
    end

    test "search is case insensitive" do
        get biographies_path(:search=>"title1")
        biographies = @controller.index
        assert_equal(1, biographies.length)
        assert_select 'table#index' do
            assert_select 'tr', 1
        end
        assert_equal(biographies[0].title, "TITLE1")
    end

    test "search displays message if no results" do
        get biographies_path(:search=>"nothing mathches this")
        biographies = @controller.index
        assert_equal(0, biographies.length)
        assert_select 'table#index' do
            assert_select 'tr', 1 do
                assert_select 'td', "No results"
            end
        end
    end

    test "pagination returns subset of biographies for index" do
        for x in 1..100 do
            Biography.create(title: x, slug: x, body: x)
        end
        get biographies_path(:index)
        biographies = @controller.index
        assert_operator( Biography.all.length, :>, 25)
        assert_equal(25, biographies.length)
        DatabaseCleaner.clean
    end

    test "pagination returns subset of biographies for search" do
        for x in 1..100 do
            Biography.create(title: "John", slug: x, body: x)
        end
        get biographies_path(:search=>"John")
        biographies = @controller.index
        assert_operator( Biography.all.length, :>, 25)
        assert_equal(25, biographies.length)
        DatabaseCleaner.clean
    end

    test "new renders empty biography form" do
        sign_in @u1
        get new_biography_path
        assert_response :success
        assert_nil assigns(:biography).title
        assert_nil assigns(:biography).lifespan
        assert_nil assigns(:biography).body
        assert_nil assigns(:biography).authors
        assert_nil assigns(:biography).slug
        assert_nil assigns(:biography).primary_country
        assert_nil assigns(:biography).secondary_country
        assert_nil assigns(:biography).south_georgia
    end

    test "Summernote elements are present" do
        sign_in @u1
        get new_biography_path
        assert_select "textarea#biography_body[data-provider='summernote']"
        Biography.destroy_all
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        get edit_biography_path(@b)
        assert_select "textarea#biography_body[data-provider='summernote']"
    end

    test "creates biography with correct params and redirects to show" do
        sign_in @u1
        Biography.destroy_all
        Country.destroy_all
        Country.create(id: 12, "name": "Country 1")
        Country.create(id: 1, "name": "Country 2")
        assert_difference('Biography.count') do
            post biographies_path, params: { biography: { title: 'Biography Title',
                                                            slug: 'biography_title',
                                                            body: 'Biography body',
                                                            authors: 'Authors',
                                                            lifespan: '1921-1987',
                                                            revisions: '2017 - Joe Blow',
                                                            south_georgia: false,
                                                            primary_country_id: 12,
                                                            secondary_country_id: 1
                                                            }}
        end
        assert_redirected_to biography_path(Biography.last)
    end

    test "re-renders new form if validation fails on create" do
        sign_in @u1
        assert_no_difference('Biography.count') do
            post biographies_path, params: { biography: { title: 'Biography Title',
                                                            slug: '',
                                                            body: 'Biography body' }}
        end
        assert_template :new
        assert_not_nil assigns(:biography)
    end

    test "edit returns populated form" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        get edit_biography_path(@b)
        assert_response :success
        assert_select "input#biography_title[value=?]", "Original title"
        assert_equal assigns(:biography).title, @b.title
        assert_equal assigns(:biography).slug, @b.slug
        assert_equal assigns(:biography).body, @b.body
    end

    test "updates biography with correct params and redirects to show" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        patch biography_url(@b), params: { biography: { title: "Updated title" } }
        assert_redirected_to biography_path(@b)
        @b.reload
        assert_equal "Updated title", @b.title
    end

    test "re-renders new form if validation fails on update" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        patch biography_path(@b), params: { biography: { title: nil }}
        assert_template :edit
        assert_not_nil assigns(:biography)
    end

    test "delete will delete biography" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        assert_difference('Biography.count', -1) do
            delete biography_path(@b)
        end
        assert_redirected_to biographies_path
    end

    test "delete, edit, back buttons present in detail views if signed in" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        get biography_path(@b)
        assert_select "a.btn[href=?]", biographies_path, {:text => "Back"}
        assert_select "a.btn[href=?]", edit_biography_path(@b), {:text => "Edit"}
        assert_select "a.btn[href=?]", biography_path, {:text => "Delete"}
    end

    test "delete, edit, back buttons not present in detail views if not signed in" do
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        get biography_path(@b)
        assert_select "a.btn", false, {:text => "Delete"}
        assert_select "a.btn", false, {:text => "Edit"}
    end

    test "new, delete, edit, back buttons present in list view if signed in" do
        sign_in @u1
        get biographies_path
        assert_select "a.btn", {:text => "New", :count => 1}
        assert_select "a.btn", {:text => "Edit", :count => Biography.count}
        assert_select "a.btn", {:text => "Delete", :count=> Biography.count}
    end

    test "new, delete, edit, back buttons not present in list view if logged out" do
        get biographies_path
        assert_select "a.btn", false, {:text => "New"}
        assert_select "a.btn", false, {:text => "Edit"}
        assert_select "a.btn", false, {:text => "Delete"}
    end

    test "redirected if not logged in, for all crud" do
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        delete biography_path(@b)
        assert_redirected_to new_user_session_path

        get edit_biography_path(@b)
        assert_redirected_to new_user_session_path

        post biographies_path, params: { biography: { title: 'Biography Title',
                                                        slug: '',
                                                        body: 'Biography body' }}
        assert_redirected_to new_user_session_path

        patch biography_url(@b), params: { biography: { title: "Updated title" } }
        assert_redirected_to new_user_session_path

        get new_biography_path
        assert_redirected_to new_user_session_path

    end

    test "can reset featured biographies if logged in" do
        sign_in @u1
        Biography.destroy_all
        Image.destroy_all
        image = fixture_file_upload 'files/test_image_3.png', 'image/png'
        for x in 1..50 do
            @b = Biography.create(id: x, title: x, slug: x, body: x, authors: "authors", lifespan: "lifespan", featured: false)
            @i = Image.create(biography: @b, title: x, caption: x, image: image )
        end
        Biography.find(1).update(featured: true)
        Biography.find(2).update(featured: true)
        Biography.find(4).update(featured: true)
        assert_equal [1, 2, 4], Biography.where(featured: true).order(:id).pluck(:id)
        get '/biographies/reset_featured'
        assert_not_equal [1, 2, 4], Biography.where(featured: true).order(:id).pluck(:id)
    end

    test "cannot reset featured biographies if not logged in" do
        get '/biographies/reset_featured'
        assert_redirected_to new_user_session_path
    end

    test "can set featured using form" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body", featured: false)
        patch biography_url(@b), params: { biography: { featured: true } }
        assert_redirected_to biography_path(@b)
        @b.reload
        assert_equal true, @b.featured
    end

    teardown do
        DatabaseCleaner.clean
    end

end
