require "test_helper"

class BookControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get book_create_url
    assert_response :success
  end
end
