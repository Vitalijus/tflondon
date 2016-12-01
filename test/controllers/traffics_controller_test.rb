require 'test_helper'

class TrafficsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get traffics_index_url
    assert_response :success
  end

end
