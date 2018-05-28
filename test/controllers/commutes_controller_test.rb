require 'test_helper'

class CommutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @commute = commutes(:one)
  end

  test "should get index" do
    get commutes_url
    assert_response :success
  end

  test "should get new" do
    get new_commute_url
    assert_response :success
  end

  test "should create commute" do
    assert_difference('Commute.count') do
      post commutes_url, params: { commute: { label: @commute.label, location_id: @commute.location_id, recurring: @commute.recurring, start_time: @commute.start_time } }
    end

    assert_redirected_to commute_url(Commute.last)
  end

  test "should show commute" do
    get commute_url(@commute)
    assert_response :success
  end

  test "should get edit" do
    get edit_commute_url(@commute)
    assert_response :success
  end

  test "should update commute" do
    patch commute_url(@commute), params: { commute: { label: @commute.label, location_id: @commute.location_id, recurring: @commute.recurring, start_time: @commute.start_time } }
    assert_redirected_to commute_url(@commute)
  end

  test "should destroy commute" do
    assert_difference('Commute.count', -1) do
      delete commute_url(@commute)
    end

    assert_redirected_to commutes_url
  end
end
