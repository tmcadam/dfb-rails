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

    teardown do
        Biography.destroy_all
        Image.destroy_all
    end

end
