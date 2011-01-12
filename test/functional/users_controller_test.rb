require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => User.first
    assert_template 'show'
  end

  def test_update_invalid
    User.any_instance.stubs(:valid?).returns(false)
    put :update, :id => User.first
    assert_template 'edit'
  end

  def test_update_valid
    User.any_instance.stubs(:valid?).returns(true)
    put :update, :id => User.first
    assert_redirected_to user_url(assigns(:user))
  end
end
