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
        first = get_random_ids(Biography.all)
        second = get_random_ids(Biography.all)
        third = get_random_ids(Biography.all)
        assert_equal 3, first.length
        assert_equal 3, second.length
        assert_equal 3, third.length
        assert_not_equal first, second
        assert_not_equal second, third
        assert_not_equal first, third
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
        @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
        @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.google.com">Link2</a>')
        @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
        links = gather_all_links
        assert_equal 3, links.length
        assert_equal "Link1", links.first[:title]
        assert_equal "http://www.google.com", links.first[:url]
        assert_equal @b1.id, links.first[:bio]
    end

    test "check_links returns fails if links bad" do
      @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
      @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.goog-ERROR-le.com">Link2</a>')
      @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
      fails = check_links
      assert_equal 1, fails.length
      assert_equal "Link2", fails.first[:title]
      assert_equal "http://www.goog-ERROR-le.com", fails.first[:url]
      assert_equal @b2.id, fails.first[:bio]
    end

    test "check_links returns no fails if links good" do
      @b1 = Biography.create(title: "1", slug: "1", body: "1", external_links: '<a href="http://www.google.com">Link1</a>')
      @b2 = Biography.create(title: "2", slug: "2", body: "2", external_links: '<a href="http://www.google.com">Link2</a>')
      @b3 = Biography.create(title: "3", slug: "3", body: "3", references: '<a href="http://www.google.com">Link3</a>')
      fails = check_links
      assert_equal 0, fails.length
    end

    teardown do
        Biography.destroy_all
        Image.destroy_all
    end

end
