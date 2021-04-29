require 'test_helper'

class ImageTest < ActiveSupport::TestCase

    setup do
        DatabaseCleaner.clean
        @b = Biography.create(title: "Brian Black", slug: "brian_black")
        image1 = fixture_file_upload 'test_image_1.jpg', 'image/jpg'
        @i1 = Image.new(biography: @b, title:"Image1", caption:"Brian at work", image: image1)
        image2 = fixture_file_upload 'test_image_2.tif', 'image/tif'
        @i2 = Image.new(biography: @b, title:"Image1", caption:"Brian at work", image: image2)
        image3 = fixture_file_upload 'test_image_3.png', 'image/png'
        @i3 = Image.new(biography: @b, title:"Image1", caption:"Brian at work", image: image3)
    end

    test "valid image with all attributes present and correct" do
        assert @i1.valid?
    end

    test "image saves if valid with jpg" do
        assert @i1.save
        assert File.file?(@i1.image.path("thumb"))
        assert File.file?(@i1.image.path("medium"))
        assert File.file?(@i1.image.path("original"))
    end

    test "image saves if valid with tif" do
        assert @i2.save
        assert File.file?(@i2.image.path("thumb"))
        assert File.file?(@i2.image.path("medium"))
        assert File.file?(@i2.image.path("original"))
    end

    test "image saves if valid with png" do
        assert @i3.save
        assert File.file?(@i3.image.path("thumb"))
        assert File.file?(@i3.image.path("medium"))
        assert File.file?(@i3.image.path("original"))
    end

    test "is not valid without image" do
        @i1.image = nil
        assert_not @i1.valid?
    end

    test "is not valid without title" do
        @i1.title = nil
        assert_not @i1.valid?
    end

    test "is not valid without caption" do
        @i1.caption = nil
        assert_not @i1.valid?
    end

    test "large images are downsized to correct sizes" do
        @i1.save
        geometry = Paperclip::Geometry.from_file(@i1.image.path("original"))
        assert_includes [geometry.width, geometry.height], 800
        assert_operator geometry.width, :<=, 800
        assert_operator geometry.height, :<=, 800
        geometry = Paperclip::Geometry.from_file(@i1.image.path("medium"))
        assert_includes [geometry.width, geometry.height], 300
        assert_operator geometry.width, :<=, 300
        assert_operator geometry.height, :<=, 300
        geometry = Paperclip::Geometry.from_file(@i1.image.path("thumb"))
        assert_includes [geometry.width, geometry.height], 100
        assert_operator geometry.width, :<=, 100
        assert_operator geometry.height, :<=, 100
    end

    test "small images don't get resized" do
        @i3.save
        geometry = Paperclip::Geometry.from_file(@i3.image.path("original"))
        assert_equal 100, geometry.width
        assert_equal 86, geometry.height
        geometry = Paperclip::Geometry.from_file(@i3.image.path("medium"))
        assert_equal 100, geometry.width
        assert_equal 86, geometry.height
        geometry = Paperclip::Geometry.from_file(@i3.image.path("thumb"))
        assert_equal 100, geometry.width
        assert_equal 86, geometry.height
    end

    test "clean_urls cleans links in body on save" do
        @i1.caption = "https://www.falklandsbiographies.org/biographies/robert_brown blah blah"
        @i1.save
        @i1.reload
        assert_equal "/biographies/robert_brown blah blah", @i1.caption
    end

    teardown do
        @i1.destroy
        @i2.destroy
        @i3.destroy
    end

end
