require 'test_helper'

class BiographiesHelperTest < ActionView::TestCase

    test "clear featured, clears all featured" do
        for x in 1..3 do
            Biography.create(title: x, slug: x, body: x, featured: true)
        end
        assert_equal 3, Biography.where('featured = ?', true).count
        clear_featured
        assert_equal 0, Biography.where('featured = ?', true).count
    end

    test "with_images, gets only with images" do
        image = fixture_file_upload "#{Rails.root}/test/fixtures/files/test_image_3.png", 'image/png'
        for x in 1..10 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
            if x <= 5
                @i = Image.create(biography: @b, title: x, caption: x, image: image )
            end
        end
        assert_equal 5, with_images(Biography.all).count
    end

    test "with_lifespan_author, gets rid of the stub biographies" do
        Biography.destroy_all
        for x in 1..10 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
            if x <= 5
                @b.update(lifespan:"has lifespan", authors: "has authors")
            end
        end
        assert_equal 5, with_lifespan_author(Biography.all).count
    end

    test "get_random_ids, produces array of ids" do
        Biography.destroy_all
        for x in 1..10 do
            @b = Biography.create(title: x, slug: x, body: x, featured: true)
        end
        first = get_random_ids(Biography.all.pluck(:id), 3)
        second = get_random_ids(Biography.all.pluck(:id), 3)
        third = get_random_ids(Biography.all.pluck(:id), 3)
        assert_equal 3, first.length
        assert_equal 3, second.length
        assert_equal 3, third.length
        assert_not_equal first, second
        assert_not_equal second, third
        assert_not_equal first, third
    end

    test "with_first_image_orientated returns an array of biography ids with specific orientation" do
        #Biography.destroy_all
        image2 = fixture_file_upload 'test_image_2.tif', 'image/tif'
        image4 = fixture_file_upload 'test_image_4.jpg', 'image/jpg'

        @b1 = biographies(:one)
        @b2 = biographies(:two)
        @b3 = biographies(:three)
        Image.create(biography: @b1, title:"Landscape1", caption:"Brian at work", image: image2)
        Image.create(biography: @b2, title:"Portrait1", caption:"Brian at work", image: image4)
        Image.create(biography: @b3, title:"Portrait2", caption:"Brian at work", image: image4)

        assert_equal 3, Biography.all.count
        assert_equal 3, Image.all.count
        # puts with_first_image_orientated(Biography.all, "portrait")
        # puts with_first_image_orientated(Biography.all, "landscape")
        assert_equal 2, with_first_image_orientated(Biography.all, "portrait").length
        assert with_first_image_orientated(Biography.all, "portrait").include? @b2.id
        assert with_first_image_orientated(Biography.all, "portrait").include? @b3.id 

        assert_equal 1, with_first_image_orientated(Biography.all, "landscape").length
        assert with_first_image_orientated(Biography.all, "landscape").include? @b1.id
    end

    test "get_features, selects from bios by id" do
        Biography.destroy_all
        for x in 1..10 do
            @b = Biography.create(id: x, title: x, slug: x, body: x, featured: true)
        end
        assert_equal 3, get_features([1, 2, 3]).count
        assert_equal 1, get_features([1, 2, 3]).order(:id).first.id
        assert_equal 3, get_features([1, 2, 3]).order(:id).last.id
    end

    test "set_featured, sets bios to featured" do
        Biography.destroy_all
        for x in 1..10 do
            @b = Biography.create(id: x, title: x, slug: x, body: x, featured: false)
        end
        set_featured(Biography.where(id: [1, 2, 3]))
        assert_equal true, Biography.find(1).featured
        assert_equal true, Biography.find(2).featured
        assert_equal true, Biography.find(3).featured
    end

    test "gather_all_links collects links from bios" do
        Biography.destroy_all
        @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
        @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.google.com">Link2</a>')
        @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
        links = gather_all_links
        assert_equal 3, links.length
        assert_equal "Link1", links.first[:title]
        assert_equal "http://www.google.com", links.first[:url]
        assert_equal @b1, links.first[:bio]
    end


    test "gather_all_links adds a reformatted youtube url to link hash" do
        Biography.destroy_all
        @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="https://www.youtube.com/watch?v=x7X-TN64Qb0">Link1</a>')
        links = gather_all_links
        assert_equal 1, links.length
        assert_equal "Link1", links.first[:title]
        assert_equal "https://www.youtube.com/watch?v=x7X-TN64Qb0", links.first[:url]
        assert_equal "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=x7X-TN64Qb0&format=json", links.first[:youtube_url]
        assert_equal @b1, links.first[:bio]
    end

    test "check_links returns fails if links bad" do
      Biography.destroy_all
      @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
      @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
      @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
      @b2 = Biography.create(title: "4", slug: "4", body: "4", external_links: '<a href="http://www.google.com/sfdsfsf">Link4</a>')
      result = check_links_in_bios
      assert_equal 4, result[:count]
      assert_equal 2, result[:fails].length
      assert_not_nil result[:fails].detect {|f| f[:title] == "Link2" }
      assert_not_nil result[:fails].detect {|f| f[:title] == "Link4" }
    end

    test "check_links returns no fails if links good" do
      Biography.destroy_all
      @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
      @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.facebook.com">Link2</a>')
      @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="https://api.parliament.uk/historic-hansard/people/dr-david-owen/index.html">Link3</a>')
      result = check_links_in_bios
      assert_equal 3, result[:count]
      assert_equal 0, result[:fails].length
    end

    test "links_report returns fails if links bad" do
      Biography.destroy_all
      @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
      @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
      @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
      links_report
    end

    teardown do
      Image.destroy_all
      Comment.destroy_all
      Biography.destroy_all
    end

end
