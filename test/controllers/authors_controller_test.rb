require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest

    test "can show authors index" do
        get authors_path
        assert_response :success
    end

end
