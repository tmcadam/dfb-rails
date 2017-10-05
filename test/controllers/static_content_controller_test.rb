require 'test_helper'

class StaticContentControllerTest < ActionDispatch::IntegrationTest

    test "can show static content using slug" do
        get static_content_path("home") #uses one of the fixtures
        assert_response :success
    end

    test "404 if static_content slug not found" do
        assert_raises(ActiveRecord::RecordNotFound) {get static_content_path("slug_typo")}
    end

    test "can show static content at root urls not static_content urls" do
        get static_content_path("home")
        assert_response :success
    end

    test "root url redirects to static_content home" do
        get "/"
        assert_response :redirect
        assert_redirected_to static_content_path("home")
    end

end
