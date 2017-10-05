require 'test_helper'

class StaticContentControllerTest < ActionDispatch::IntegrationTest

    test "can show static content using slug" do
        get static_content_path("home") #uses one of the fixtures
        assert_response :success
    end

    test "404 if static_content slug not found" do
        assert_raises(ActiveRecord::RecordNotFound) {get static_content_path("slug_typo")}
    end

    test "can show static content at root urls" do
        get "/home"
        assert_response :success
    end

end
