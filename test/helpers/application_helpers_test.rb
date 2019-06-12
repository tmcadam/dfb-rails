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

    test "clean_html_tags, strips out unwanted tags and properties" do
      string1 = '<p style="blah:45;blah:62;">Some content</p>'
      expected1 = '<p>Some content</p>'
      assert_equal expected1, clean_html(string1)

      string2 = '<p style="text-align:justify"><span style="mso-bidi-font-family:Calibri;mso-bidi-theme-font:minor-latin">Lynch’s final naval appointments were inHMS <i style="mso-bidi-font-style:normal">Blackcap</i>, RNAS Stretton</span></p>'
      expected2 = '<p><span>Lynch’s final naval appointments were inHMS <i>Blackcap</i>, RNAS Stretton</span></p>'
      assert_equal expected2, clean_html(string2)

      string3 = '<p>    </p><p>Blah Blah</p>'
      expected3 = '<p>Blah Blah</p>'
      assert_equal expected3, clean_html(string3)
    end

end
