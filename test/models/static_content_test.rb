require 'test_helper'

class StaticContentTest < ActiveSupport::TestCase

    test "clean_urls cleans links in body on save" do
        @h = static_contents(:about)
        @h.body = "https://www.falklandsbiographies.org/biographies/robert_brown blah blah"
        @h.save
        @h.reload
        assert_equal "/biographies/robert_brown blah blah", @h.body
    end

end
