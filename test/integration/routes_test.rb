# /tests/integration/routes_test.rb
require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "route test" do
    assert_routing "/biographies/1", { :controller => "biographies", :action => "show", :id => "1" }
  end

end
