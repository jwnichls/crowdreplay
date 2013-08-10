require 'test_helper'

class RecordersControllerTest < ActionController::TestCase
  setup do
    @recorder = recorders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recorders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recorder" do
    assert_difference('Recorder.count') do
      post :create, recorder: { category: @recorder.category, oauth_access_secret: @recorder.oauth_access_secret, oauth_access_token: @recorder.oauth_access_token, query: @recorder.query, running: @recorder.running, status: @recorder.status }
    end

    assert_redirected_to recorder_path(assigns(:recorder))
  end

  test "should show recorder" do
    get :show, id: @recorder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recorder
    assert_response :success
  end

  test "should update recorder" do
    put :update, id: @recorder, recorder: { category: @recorder.category, oauth_access_secret: @recorder.oauth_access_secret, oauth_access_token: @recorder.oauth_access_token, query: @recorder.query, running: @recorder.running, status: @recorder.status }
    assert_redirected_to recorder_path(assigns(:recorder))
  end

  test "should destroy recorder" do
    assert_difference('Recorder.count', -1) do
      delete :destroy, id: @recorder
    end

    assert_redirected_to recorders_path
  end
end
