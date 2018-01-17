require 'test_helper'

class BiographyAuthorsNestedControllerTest < ActionDispatch::IntegrationTest

    setup do
        @u1 = User.create(email: "guy@gmail.com", password: "111111", password_confirmation: "111111" )
    end

    test "edit returns populated form, including inline authors fields" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        BiographyAuthor.create(biography: @b, author: @a2, author_position: 2) #link biography and authors
        get edit_biography_path(@b)
        assert_response :success
        assert_select 'select#biography_biography_authors_attributes_0_author_id option[selected]', "Bob Author1"
        assert_select 'input#biography_biography_authors_attributes_0_author_position[value=?]', "1"
        assert_select 'select#biography_biography_authors_attributes_1_author_id option[selected]', "Jim Author2"
        assert_select 'input#biography_biography_authors_attributes_1_author_position[value=?]', "2"
    end

    test "updates biographyauthor with inline authors params biography form" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 2) #link biography and authors
        patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{id: @ba1.id, author_id: @a2.id, author_position: 1 }] } }
        @ba1.reload
        assert_equal @ba1.author, @a2
        assert_equal @ba1.author_position, 1
    end

    test "can destroy BiographyAuthor through nested parameters" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        @ba2 = BiographyAuthor.create(biography: @b, author: @a2, author_position: 2) #link biography and authors
        assert_difference('BiographyAuthor.count', -1) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{id: @ba2.id, author_id: @a2.id, author_position: 1, _destroy: true }] } }
        end
    end

    test "can create BiographyAuthor through nested parameters" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        assert_difference('BiographyAuthor.count', 1) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: @a2.id, author_position: 2 }] } }
        end
    end

    test "cannot create blank BiographyAuthor through nested parameters" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: '', author_position: '' }] } }
        end
    end

    test "cannot destroy BiographyAuthor by setting fields to blank" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        @ba2 = BiographyAuthor.create(biography: @b, author: @a2, author_position: 2) #link biography and authors
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{id: @ba2.id, '': @a2.id, author_position: '' }] } }
        end
    end

    test "cannot create blank BiographyAuthor with missing author or author_position" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: '', author_position: '' }] } }
        end
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: @a2.id, author_position: '' }] } }
        end
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: '', author_position: '2' }] } }
        end
    end

    test "cannot create duplicate BiographyAuthor" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: @a1.id, author_position: 1 }] } }
        end
    end

    test "cannot create duplicate BiographyAuthor(with different positions)" do
        sign_in @u1
        @b = Biography.create(title: "Original title", slug: "a_slug", body: "A body")
        @a1 = Author.create(first_name: "Bob", last_name:"Author1", biography:"Biography of author")
        @a2 = Author.create(first_name: "Jim", last_name:"Author2", biography:"Biography of author")
        @ba1 = BiographyAuthor.create(biography: @b, author: @a1, author_position: 1) #link biography and authors
        assert_difference('BiographyAuthor.count', 0) do
            patch biography_url(@b), params: { biography: { title: "Updated title", biography_authors_attributes: [{author_id: @a1.id, author_position: 2 }] } }
        end
    end

    teardown do
        DatabaseCleaner.clean
    end

end
