module ColorsHelper
  def colors_bar colors=[], options={}
    render :partial => 'shared/colors_bar', :locals => { :colors => colors }
  end
end
