require "test_helper"

class AuthorTest < ActiveSupport::TestCase
    setup do
        DatabaseCleaner.clean
        @a1 = Author.new(name:"Author1", biography:"Biography of author", contributions:"Authors contributions")
        @a2 = Author.new(name:"Author2", biography:"Biography of author", contributions:"Authors contributions")
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

    test "author without contributions is invalid" do
        @a1.contributions = nil
        assert_not @a1.valid?
    end

    test "author with duplicatename is invalid" do
        @a1.save
        @a2.name = "Author1"
        assert_not @a2.valid?
    end

end
