require 'test_helper'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get imports_index_url
    assert_response :success
  end

  test "should get new" do
    get imports_new_url
    assert_response :success
  end

  test "should get show" do
    get imports_show_url
    assert_response :success
  end

  test "should get edit" do
    get imports_edit_url
    assert_response :success
  end

  test "should get create" do
    get imports_create_url
    assert_response :success
  end

  test "should get update" do
    get imports_update_url
    assert_response :success
  end

  test "should get destroy" do
    get imports_destroy_url
    assert_response :success
  end

end
