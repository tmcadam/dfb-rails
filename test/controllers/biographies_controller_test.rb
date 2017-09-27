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
        assert_equal(2, biographies.length)
        assert_select 'table#index' do
            assert_select 'tr', 2
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


end
