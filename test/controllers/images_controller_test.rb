require 'test_helper'

class ImageControllerTest < ActionDispatch::IntegrationTest

    setup do
        @b = Biography.create(title: "Brian Black", slug: "brian_black")
        @image = fixture_file_upload 'files/test_image_3.png', 'image/png'
        @img1 = Image.create( id: 1, biography: @b, title: "Bob Bobber", caption: "Bob at work", image: @image)
        @img2 = Image.create( id: 2, biography: @b, title: "Mike Michaels", caption: "Mike at work", image: @image)
        ActiveRecord::Base.connection.reset_pk_sequence!('images')
    end

    test "can show image page using id" do
        get image_path(1) # uses one of the fixtures
        assert_response :success
        assert_not_nil assigns(:image)
    end

    test "can show image using links" do
        image = Image.find(1)
        get image.image.url("original")
        assert_response :success
        get image.image.url("medium")
        assert_response :success
        get image.image.url("thumb")
        assert_response :success
    end

    test "can show images index" do
        get images_path
        assert_response :success
        assert_not_nil assigns(:images)
    end

    test "index route returns all images" do
        get images_path
        images = @controller.index
        assert_equal(2, images.length)
        assert_select 'table#index' do
            assert_select 'tr', 2
        end
        assert_not_nil assigns(:images)
    end

    test "new images returns empty form" do
        get new_image_path
        assert_response :success
        assert_nil assigns(:image).title
        assert_nil assigns(:image).biography_id
        assert_nil assigns(:image).caption
        assert_nil assigns(:image).image_file_name
        assert_select "form#new_image"
        assert_select "input#image_title" do
            assert_select ":match('value', ?)", /.+/, false
        end
    end

    test "edit returns populated form" do
        get edit_image_path(@img1)
        assert_response :success
        assert_select "form#edit_image_1"
        assert_select "input#image_title" do
            assert_select "[value=?]", "Bob Bobber"
        end
        assert_equal assigns(:image).title, @img1.title
        assert_equal assigns(:image).caption, @img1.caption
        assert_equal assigns(:image).biography_id, @img1.biography_id
        assert_equal assigns(:image).image_file_name, @img1.image_file_name
    end

    test "edit form shows preview of img" do
        get edit_image_path(@img1)
        image = @controller.edit
        assert_select "img" do
            assert_select "[src=?]", image.image.url("medium")
        end
    end

    test "creates image with correct params and redirects to show" do
        assert_difference('Image.count') do
            post images_path, params: {     image: { biography_id: 1,
                                                     image: @image,
                                                     title: 'Image title',
                                                     caption: 'Image caption' }}
        end
        assert_redirected_to image_path(Image.last)
    end

    test "re-renders new form if validation fails on create" do
        assert_no_difference('Image.count') do
            post images_path, params: {     image: { biography_id: 1,
                                            title: 'Image title',
                                            caption: 'Image caption' }}
        end
        assert_template :new
        assert_not_nil assigns(:image)
    end

    test "updates image with correct params and redirects to show" do
      patch image_url(@img1), params: { image: { title: "Updated title" } }
      assert_redirected_to image_path(@img1)
      @img1.reload
      assert_equal "Updated title", @img1.title
    end

    test "re-renders new form if validation fails on update" do
        patch image_path(@img1), params: { image: { title: nil }}
        assert_template :edit
        assert_not_nil assigns(:image)
    end

    test "delete will delete image and files" do
        assert_difference('Image.count', -1) do
            delete image_path(@img1)
        end
        assert_not File.file?(@img1.image.path("original"))
        assert_not File.file?(@img1.image.path("medium"))
        assert_not File.file?(@img1.image.path("thumb"))
        assert_redirected_to images_path
    end

    teardown do
        DatabaseCleaner.clean
    end

end
