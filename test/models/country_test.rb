require "test_helper"

class CountryTest < ActiveSupport::TestCase

    setup do
        @c1 = Country.new(name: "Name1")
        @c2 = Country.new(name: "Name2")
    end

    test "valid country with name" do
        assert @c1.valid?
    end

    test "can save valid country" do
        assert @c1.save
    end

    test "country with no name invalid" do
        @c1.name = nil
        assert_not @c1.valid?
    end

    test "country invalid if name already exists" do
        @c1.save
        @c2.name = "Name1"
        assert_not @c2.valid?
    end

    teardown do
        DatabaseCleaner.clean
    end

end
