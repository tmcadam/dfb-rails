require 'test_helper'

class BiographyTest < ActiveSupport::TestCase

    setup do
        @b = Biography.new( title: "David",
                            lifespan: "1921-1971",
                            body: "Some body text",
                            authors: "Joe Blow",
                            slug: "some_slug")
    end

    test "valid biography with all attributes present and correct" do
        assert @b.valid?
    end

    test "can save biogrpahy with all attributes present" do
        assert @b.save
    end

    test "is not valid biography without slug" do
        @b.slug = nil
        assert_not @b.valid?
    end

    test "is not valid if slug already exists" do
        @b.slug = "slug_name1"
        assert_not @b.valid?
    end

end
