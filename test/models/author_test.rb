require "test_helper"

class AuthorTest < ActiveSupport::TestCase
    setup do
        DatabaseCleaner.clean
        @a1 = Author.new(name:"Author1", biography:"Biography of author")
        @a2 = Author.new(name:"Author2", biography:"Biography of author")
    end

    test "valid author is valid with all attributes present and correct" do
        assert @a1.valid?
    end

    test "can save valid author to db" do
        assert @a1.save
    end

    test "author without name is invalid" do
        @a1.name = nil
        assert_not @a1.valid?
    end

    test "author with duplicatename is invalid" do
        @a1.save
        @a2.name = "Author1"
        assert_not @a2.valid?
    end

    test "can add author to a biography through many to many join" do
        @b = Biography.new(title: "Bio1", slug: "bio1", body: "Bio  1")
        @b.save

        @b.biography_authors.create(author: @a1, author_position: 1)
        assert_equal @b.biography_authors.length, 1
        assert_equal Author.all.length, 1
        assert_equal @b.biography_authors.first.author.name, "Author1"

        @b.biography_authors.create(author: @a2, author_position: 2)
        assert_equal @b.biography_authors.length, 2
        assert_equal Author.all.length, 2
        assert_equal @b.biography_authors.first.author.name, "Author1"
        assert_equal @b.biography_authors.last.author.name, "Author2"
    end

    test "can add biography to authors through many to many join" do
        @b = Biography.new(title: "Bio1", slug: "bio1", body: "Bio  1")
        @a1.save

        @a1.biography_authors.create(biography: @b, author_position: 1)
        assert_equal @a1.biography_authors.length, 1
    end

    test "can access authors biographies through shortcut 'biographys'" do
        @b1 = Biography.new(title: "Bio1", slug: "bio1", body: "Bio  1")
        @b2 = Biography.new(title: "Bio2", slug: "bio2", body: "Bio  2")
        @a1.save; @b1.save; @b2.save

        @a1.biography_authors.create(biography: @b1, author_position: 1)
        @a1.biography_authors.create(biography: @b2, author_position: 1)
        assert_equal @a1.biographys.length, 2
    end

end
