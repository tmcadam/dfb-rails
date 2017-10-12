require 'test_helper'

class StaticContentControllerTest < ActionDispatch::IntegrationTest

    setup do
        @home = static_contents(:home)
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

end
