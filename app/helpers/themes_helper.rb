module ThemesHelper
  def theme_show theme
    render :partial => 'themes/theme',  :locals => { :theme => theme }
  end
  def theme_header theme
    render :partial => 'themes/header', :locals => { :theme => theme }
  end
end
