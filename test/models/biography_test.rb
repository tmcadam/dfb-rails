require 'test_helper'

class BiographyTest < ActiveSupport::TestCase

    setup do
        @b = biographies(:three)
        image = fixture_file_upload 'test_image_3.png', 'image/png'
        @b.images << Image.new( id: 1, biography: @b, title: "1", caption: "1", image: image )
        @b.images << Image.new( id: 3, biography: @b, title: "3", caption: "3", image: image )
        @b.images << Image.new( id: 2, biography: @b, title: "2", caption: "2", image: image )
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

    test "is not valid if title is not present" do
        @b.title = nil
        assert_not @b.valid?
    end

    test "is not valid if body is not present" do
        @b.body = nil
        assert_not @b.valid?
    end

    test "biographies returned by ascending title" do
        assert_equal Biography.first.title, "TITLE1"
        assert_equal Biography.last.title,  "TITLE3"
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
        assert tag.include? "biography-img"
        tag = @b.instance_eval{ insert_image(3, images) }
        assert tag.include? "biography-img"
        tag = @b.instance_eval{ insert_image(5, images) }
        assert tag.include? "biography-img"
        tag = @b.instance_eval{ insert_image(2, images) }
        assert_equal "", tag
        tag = @b.instance_eval{ insert_image(4, images) }
        assert_equal "", tag
    end

    test "body_with_images inserts images if images present" do
        tags = Nokogiri::HTML.fragment(@b.body_with_images).element_children
        assert_not_equal @b.body, @b.body_with_images
        assert_equal 11, tags.length
        assert_equal "p", tags[0].name
        assert tags[1].at_css('img')
        assert_equal "1", tags[1].css('strong').first.text
        assert tags[6].at_css('img')
        assert_equal "2", tags[6].css('strong').first.text
        assert tags[9].at_css('img')
        assert_equal "3", tags[9].css('strong').first.text
    end

    test "body_with_images makes no changes to body if no images present" do
        @b.images = []
        assert_equal @b.body, @b.body_with_images
    end

    test "has_single_author returns true if single author and returns false if multiple authors" do
        @a1 = Author.new(last_name:"Author1", biography:"Biography of author")
        @a2 = Author.new(last_name:"Author2", biography:"Biography of author")
        @b.save

        @b.biography_authors.create(author: @a1, author_position: 1)
        assert @b.has_single_author

        @b.biography_authors.create(author: @a2, author_position: 2)
        assert_not @b.has_single_author
    end

    test "other_author returns the other author for biography or nil" do
        @a1 = Author.create(last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(last_name:"Author2", biography:"Biography of author")
        @b.save

        @b.biography_authors.create(author: @a1, author_position: 1)
        assert_nil @b.other_author (@a1)

        @b.biography_authors.create(author: @a2, author_position: 2)
        assert_equal @b.other_author(@a1).name, @a2.name
    end

    test "can save biography with south_georgia" do
        @b.south_georgia = true
        @b.save
    end

    test "can save biography with primary and secondary countries" do
        @c1 = Country.create(name: "Country 1")
        @c2 = Country.create(name: "Country 2")
        @b.primary_country = @c1
        @b.secondary_country = @c2
        @b.save
        assert_equal @b.primary_country.name, "Country 1"
        assert_equal @b.secondary_country.name, "Country 2"
    end

    test "can get 'primary' biographies in country" do
        @c1 = Country.create(name: "Country 1")
        @c2 = Country.create(name: "Country 2")
        @b.primary_country = @c1
        @b.secondary_country = @c2
        @b.save
        assert_equal @c1.biographies.count, 1
        assert_equal @c1.biographies.first, @b
    end

    test "can set biography to featured" do
        @b1 = biographies(:three)
        @b2 = biographies(:two)
        @b1.update(featured: true)
        assert_equal 1, Biography.where("featured = ?", true).count
    end

    test "clean_urls cleans links in body on save" do
        @b.body = "https://www.falklandsbiographies.org/biographies/robert_brown blah blah"
        @b.save
        @b.reload
        assert_equal "/biographies/robert_brown blah blah", @b.body
    end

    test "clean_html_tags removes unwanted tags and properties" do
        @b.body = '<p>   </p><p style="blah:45;blah:46;">Blah <i>Blah</i></p>'
        @b.save
        @b.reload
        assert_equal '<p>Blah <i>Blah</i></p>', @b.body
    end

    test "gather_links returns correct number of links for testing" do
        @b.external_links = '<a href="www.google.com">Google</a></br><a href="www.yahoo.com">Yahoo</a>'
        @b.references = '<a href="www.google.com">Google</a>'
        links = @b.instance_eval{ gather_links }
        assert_equal 3, links.length

        @b.external_links = '<h1>No links</h1>'
        @b.references = '<a href="www.google.com">Google</a>'
        links = @b.instance_eval{ gather_links }
        assert_equal 1, links.length

        @b.external_links = '<h1>No links</h1>'
        @b.references = '<p></p>'
        links = @b.instance_eval{ gather_links }
        assert_equal 0, links.length
    end

    test "gather_links returns array of hashes" do
        @b.external_links = '<a href="www.google.com">Google</a></br><a href="www.yahoo.com">Yahoo</a>'
        @b.references = '<a href="www.google.com">Google</a>'
        links = @b.instance_eval{ gather_links }
        assert_equal 3, links.length

    end

    teardown do
      Image.destroy_all
      Comment.destroy_all
      Biography.destroy_all
    end

end
