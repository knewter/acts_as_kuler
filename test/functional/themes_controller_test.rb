require File.dirname(__FILE__) + '/../test_helper'

class ThemesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:themes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_theme
    assert_difference('Theme.count') do
      post :create, :theme => { }
    end

    assert_redirected_to theme_path(assigns(:theme))
  end

  def test_should_show_theme
    get :show, :id => themes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => themes(:one).id
    assert_response :success
  end

  def test_should_update_theme
    put :update, :id => themes(:one).id, :theme => { }
    assert_redirected_to theme_path(assigns(:theme))
  end

  def test_should_destroy_theme
    assert_difference('Theme.count', -1) do
      delete :destroy, :id => themes(:one).id
    end

    assert_redirected_to themes_path
  end
end
