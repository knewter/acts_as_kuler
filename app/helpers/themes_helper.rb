module ThemesHelper
  def theme_show theme
    render :partial => 'themes/theme',  :locals => { :theme => theme }
  end
  def theme_header theme
    render :partial => 'themes/header', :locals => { :theme => theme }
  end
  def big_theme_bar theme
    render :partial => 'themes/big_theme_bar', :locals => { :theme => theme }
  end
end
