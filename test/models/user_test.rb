require "test_helper"

describe User do

    setup do
        DatabaseCleaner.clean
        @u1 = User.new(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
        @u2 = User.new(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "user with email and password is valid" do
        assert @u1.valid?
    end

    test "can save valid user" do
        assert @u1.save
    end

    test "user with duplicate email is invalid" do
        @u1.save
        assert_not @u2.valid?
    end

    test "test user without email is invalid" do
        @u1.email = nil
        assert_not @u1.valid?
    end

    test "test user without password or short password is invalid" do
        @u1.password = nil
        assert_not @u1.valid?
        @u1.password = "111"
        @u1.password_confirmation = "111"
        assert_not @u1.valid?
    end

end
