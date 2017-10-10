require 'test_helper'

class BiographyTest < ActiveSupport::TestCase

    setup do
        @b = Biography.new( title: "David",
                            lifespan: "1921-1971",
                            body:   '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>'\
                                    '<h4>Section heading</h4>'\
                                    '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>'\
                                    '<blockquote>Some block quotation</blockquote>'\
                                    '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>'\
                                    '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>'\
                                    '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>'\
                                    '<p>Nulla viverra, ipsum ac pretium dignissim, ligula neque egestas orci, vel cursus ante nibh eu odio. Nullam nec consectetur erat. Nullam finibus tincidunt dui eu tristique. Donec varius ac sapien sit amet posuere. Proin luctus interdum est, eu vestibulum augue maximus eget. In pellentesque orci amet.</p>',
                            authors: "Joe Blow",
                            slug: "some_slug")

        image = fixture_file_upload 'files/test_image_3.png', 'image/png'
        @b.images << Image.new( biography: @b, title: "1", caption: "1", image: image )
        @b.images << Image.new( biography: @b, title: "2", caption: "2", image: image )
        @b.images << Image.new( biography: @b, title: "3", caption: "3", image: image )
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

    test "biographies returned by ascending title" do
        assert_equal Biography.first.title, "TITLE1"
        assert_equal Biography.last.title,  "TITLE2"
    end

    test "get_body_elements returns correct elements" do
        elements = @b.instance_eval{ get_body_elements }
        assert_equal 8, elements.length
        assert_equal "p", elements[0].name
        assert_equal "h4", elements[1].name
        assert_equal "p", elements[2].name
        assert_equal "blockquote", elements[3].name
        assert_equal "p", elements[4].name
    end

    test "generate image tags can create tags with alternating classes" do
        tags = @b.instance_eval{ generate_image_tags }
        assert 3, tags.length
        assert tags[0]["tag"].include? "biography-img-right"
        assert tags[1]["tag"].include? "biography-img-left"
        assert tags[2]["tag"].include? "biography-img-right"
        assert_equal tags[0]["after_para"], 1
        assert_equal tags[1]["after_para"], 3
        assert_equal tags[2]["after_para"], 5
    end

    test "insert_image returns an image tag at correct paragraphs" do
        images = @b.instance_eval{ generate_image_tags }
        tag = @b.instance_eval{ insert_image(1, images) }
        assert tag.include? "biography-img-right"
        tag = @b.instance_eval{ insert_image(3, images) }
        assert tag.include? "biography-img-left"
        tag = @b.instance_eval{ insert_image(5, images) }
        assert tag.include? "biography-img-right"
        tag = @b.instance_eval{ insert_image(2, images) }
        assert_equal "", tag
        tag = @b.instance_eval{ insert_image(4, images) }
        assert_equal "", tag
    end

    test "body_with_images inserts images if images present" do
        tags = Nokogiri::HTML::fragment(@b.body_with_images).children
        assert_not_equal @b.body, @b.body_with_images
        assert_equal 11, tags.length
        assert_equal "p", tags[0].name
        assert_equal "img", tags[1].name
        assert_equal "img", tags[6].name
        assert_equal "img", tags[9].name
    end

    test "body_with_images makes no changes to body if no images present" do
        @b.images = []
        assert_equal @b.body, @b.body_with_images
    end

    teardown do
        @b.images.each do |img|
            img.destroy
        end
    end

end
