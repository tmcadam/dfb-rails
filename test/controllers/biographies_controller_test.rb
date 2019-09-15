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

        assert_select "input#biography_title",  { :count => 1 }
        assert_nil assigns(:biography).title

        assert_select "input#biography_lifespan",  { :count => 1 }
        assert_nil assigns(:biography).lifespan

        assert_select "textarea#biography_body",  { :count => 1 }
        assert_nil assigns(:biography).body

        assert_select "input#biography_authors",  { :count => 1 }
        assert_nil assigns(:biography).authors

        assert_select "input#biography_slug",  { :count => 1 }
        assert_nil assigns(:biography).slug

        assert_select "select#biography_primary_country_id",  { :count => 1 }
        assert_nil assigns(:biography).primary_country

        assert_select "select#biography_secondary_country_id",  { :count => 1 }
        assert_nil assigns(:biography).secondary_country

        assert_select "input#biography_south_georgia",  { :count => 1 }
        assert_nil assigns(:biography).south_georgia

        assert_select "textarea#biography_external_links", { :count => 1 }
        assert_nil assigns(:biography).external_links

        assert_select "textarea#biography_references", { :count => 1 }
        assert_nil assigns(:biography).references

    end

    test "Summernote elements are present" do
        sign_in @u1
        get new_biography_path
        assert_select "textarea#biography_body[data-provider='summernote']"
        assert_select "textarea#biography_external_links[data-provider='summernote']"
        assert_select "textarea#biography_references[data-provider='summernote']"
        Biography.destroy_all
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        get edit_biography_path(@b)
        assert_select "textarea#biography_body[data-provider='summernote']"
        assert_select "textarea#biography_external_links[data-provider='summernote']"
        assert_select "textarea#biography_references[data-provider='summernote']"
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
                                                            secondary_country_id: 1,
                                                            external_links: 'some external links here',
                                                            references: 'some references here'
                                                            }}
        end
        assert_equal 'Biography Title', Biography.last.title
        assert_equal 'some external links here', Biography.last.external_links
        assert_equal 'some references here', Biography.last.references
        assert_redirected_to biography_path(Biography.last.slug)
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
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body", external_links: "A link", references: "A reference")
        get edit_biography_path(@b)
        assert_response :success
        assert_select "input#biography_title[value=?]", "Original title"
        assert_equal assigns(:biography).title, @b.title
        assert_equal assigns(:biography).slug, @b.slug
        assert_equal assigns(:biography).body, @b.body
        assert_equal assigns(:biography).external_links, @b.external_links
        assert_equal assigns(:biography).references, @b.references
    end

    test "updates biography with correct params and redirects to show" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body", external_links: "A link", references: "A reference")
        patch biography_url(@b.slug), params: { biography: { title: "Updated title", external_links: "Updated link", references: "Updated reference" } }
        assert_redirected_to biography_path(@b.slug)
        @b.reload
        assert_equal "Updated title", @b.title
        assert_equal "Updated link", @b.external_links
        assert_equal "Updated reference", @b.references
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
        assert_select "a.btn[href=?]", edit_biography_path(@b.slug), {:text => "Edit"}
        assert_select "a.btn[href=?]", biography_path(@b.slug), {:text => "Delete"}
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
        patch biography_path(@b.slug), params: { biography: { featured: true } }
        assert_redirected_to biography_path(@b.slug)
        @b.reload
        assert_equal true, @b.featured
    end

    ##### Check links #####

    test "cannot check_links if not logged in" do
        get '/biographies/check_links'
        assert_redirected_to new_user_session_path
    end

    test "can see check_links menu item if logged in" do
        sign_in @u1
        get '/home'
        assert_select "a", {:text => "Check links"}
    end

    test "test check_links shows failures if failures" do
        @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
        @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
        @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
        sign_in @u1
        get '/biographies/check_links'
        assert_select "h4", "Failures"
        assert_select "a", "Link2"
    end

    test "test check_links shows No failures if no failures" do
        @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="https://www.google.com">Link1</a>')
        @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="https://www.yahoo.com">Link3</a>')
        sign_in @u1
        get '/biographies/check_links'
        assert_select "h4", "No failures"
    end

    ##### Analytics #####

    test "will render analytics js if not logged in" do
        get biographies_path
        assert_select "script#matomo"
    end

    test "will NOT render analytics js if logged in" do
        sign_in @u1
        get biographies_path
        assert_select "script#matomo", false
    end

    teardown do
        Image.destroy_all
        Comment.destroy_all
        Biography.destroy_all
    end

end
