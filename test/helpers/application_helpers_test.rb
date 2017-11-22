class ApplicationHelperTest < ActionView::TestCase

    test "clean_urls removes urls from string" do
        string1 = "https://www.falklandsbiographies.org/biographies/robert_brown blah blah"
        expected1 = "/biographies/robert_brown blah blah"
        clean_urls(string1)
        assert_equal expected1, string1

        string2 = "http://dfb-staging.ukfit.webfactional.com/biographies/robert_brown" \
                    " blah blah http://0.0.0.0:3000/home"
        expected2 = "/biographies/robert_brown blah blah /home"
        clean_urls(string2)
        assert_equal expected2, string2

    end

end
