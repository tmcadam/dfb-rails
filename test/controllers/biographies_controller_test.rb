require 'test_helper'

class BiographiesControllerTest < ActionDispatch::IntegrationTest

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
        get new_biography_path
        assert_response :success
        assert_nil assigns(:biography).title
        assert_nil assigns(:biography).lifespan
        assert_nil assigns(:biography).body
        assert_nil assigns(:biography).authors
        assert_nil assigns(:biography).slug
    end

    test "Summernote elements are present" do
        get new_biography_path
        assert_select "textarea#biography_body[data-provider='summernote']"
    end

    test "creates biography with correct params and redirects to show" do
        DatabaseCleaner.clean
        assert_difference('Biography.count') do
            post biographies_path, params: { biography: { title: 'Biography Title',
                                                            slug: 'biography_title',
                                                            body: 'Biography body',
                                                            authors: 'Authors',
                                                            lifespan: '1921-1987'}}
        end
        assert_redirected_to biography_path(Biography.last)
    end

    test "re-renders new form if validation fails on create" do
        assert_no_difference('Biography.count') do
            post biographies_path, params: { biography: { title: 'Biography Title',
                                                            slug: '',
                                                            body: 'Biography body' }}
        end
        assert_template :new
        assert_not_nil assigns(:biography)
    end

end
