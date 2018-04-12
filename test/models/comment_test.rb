require "test_helper"

describe Comment do

    setup do
        @b = biographies(:three)
        @b.save
        @c1 = Comment.new(biography: @b, name: "Tom", email: "blah@blah.com", comment: "Some comment", approved: false)
    end

    it "is valid with all required fields" do
        assert @c1.valid?
    end

    it "isn't valid without biography foreign key" do
        @c1.biography = nil
        assert_not @c1.valid?
    end

    it "isn't valid without required fields" do
        @c1.name = nil
        @c1.email = nil
        @c1.comment = nil
        assert_not @c1.valid?
    end

    it "isn't valid with out formatted email" do
        @c1.email = "blah"
        assert_not @c1.valid?
        @c1.email = "blah@blah.com"
        assert @c1.valid?
    end

    it "saves to db if valid" do
        assert_difference 'Comment.count', 1 do
            @c1.save
        end
    end

    teardown do
        DatabaseCleaner.clean
    end

end
