require 'test_helper'

class BiographiesControllerTest < ActionDispatch::IntegrationTest
    test "can get biography" do
        get biography_path(1) # uses one of the fixtures
        assert_response :success
    end
end
