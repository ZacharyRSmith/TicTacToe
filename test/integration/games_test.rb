require 'test_helper'

class GamesTest < ActionDispatch::IntegrationTest
  test "should get '/boards/index'" do
    get '/boards/index'
    assert_response :success
  end
end
