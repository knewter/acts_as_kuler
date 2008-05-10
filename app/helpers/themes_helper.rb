module ThemesHelper
  def theme_show theme
    render :partial => 'shared/theme_show', :locals => { :theme => theme }
  end
end
