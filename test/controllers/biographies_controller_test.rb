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

end
