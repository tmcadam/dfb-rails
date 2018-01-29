require "test_helper"

class AuthorTest < ActiveSupport::TestCase
    setup do
        DatabaseCleaner.clean
        @a1 = Author.new(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.new(first_name: "John", last_name:"Author2", biography:"Biography of author")
    end

    test "valid author is valid with attributes present and correct" do
        assert @a1.valid?
    end

    test "can save valid author to db" do
        assert @a1.save
    end

    test "author without last_name is invalid" do
        @a1.last_name = nil
        assert_not @a1.valid?
    end

    test "author without first_name is valid" do
        @a1.first_name = nil
        assert @a1.valid?
    end

    test "author with duplicate last_name is valid, if first_name different" do
        @a1.save
        @a2.last_name = "Author1"
        assert @a2.valid?
    end

    test "author with duplicate first_name & last_name is invalid" do
        @a1.save
        @a2.first_name = "Bob"
        @a2.last_name = "Author1"
        assert_not @a2.valid?
    end

    test "can add author to a biography through many to many join" do
        @b = Biography.new(title: "Bio1", slug: "bio1", body: "Bio  1")
        @b.save

        @a1.save
        @b.biography_authors.create(author_id: @a1.id, author_position: 1)
        assert_equal @b.biography_authors.length, 1
        assert_equal Author.all.length, 1
        assert_equal @b.biography_authors.first.author.last_name, "Author1"

        @a2.save
        @b.biography_authors.create(author: @a2, author_position: 2)
        assert_equal @b.biography_authors.length, 2
        assert_equal Author.all.length, 2
        assert_equal @b.biography_authors.first.author.last_name, "Author1"
        assert_equal @b.biography_authors.last.author.last_name, "Author2"
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

    test "test simple_slug returns a slug" do
        @a1.last_name = "Author1"
        assert_equal "bob-author1", @a1.simple_slug

        @a1.first_name = "Bob"
        @a1.last_name = "Author 1"
        assert_equal "bob-author-1", @a1.simple_slug

        @a1.first_name = nil
        @a1.last_name = "Author 1^"
        assert_equal "author-1", @a1.simple_slug
    end

    test "name joins name first_name and last_name present" do
        assert_equal "Bob Author1", @a1.name
    end

    test "name returns last_name if no first_name present" do
        @a1.first_name = nil
        assert_equal "Author1", @a1.name
    end

    test "authors are ordered by last name ascending" do
        @a2.save
        @a1.save
        assert_equal @a1, Author.first
        assert_equal @a2, Author.last
    end

    test "authors are ordered using first_name, if last_name is the same" do
        @a2.save
        @a1.last_name = "Author2"
        @a1.save
        assert_equal @a1, Author.first
        assert_equal @a2, Author.last
    end

    test "m2m biography-authors are destroyed when authors destroyed" do
        @b = Biography.create(title: "Bio1", slug: "bio1", body: "Bio  1")
        @a1.save
        @a1.biography_authors.create(biography: @b, author_position: 1)
        assert_equal @a1.biography_authors.length, 1
        assert_difference('BiographyAuthor.count', -1) do
            @a1.destroy
        end
    end

    test "not deleting biographies when deleting authors" do
        @b = Biography.create(title: "Bio1", slug: "bio1", body: "Bio  1")
        @a1.save
        @a1.biography_authors.create(biography: @b, author_position: 1)
        assert_equal @a1.biography_authors.length, 1
        assert_difference('Biography.count', 0) do
            @a1.destroy
        end
    end

end
