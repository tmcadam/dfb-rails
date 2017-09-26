require 'test_helper'

class BiographyTest < ActiveSupport::TestCase

    setup do
        @b = Biography.new( title: "David",
                            lifespan: "1921-1971",
                            body: "Some body text",
                            authors: "Joe Blow")
    end

    test "valid biography with all attributes present" do
        assert @b.valid?
    end

    test "can save biogrpahy with all attributes present" do
        assert @b.save
    end

end
