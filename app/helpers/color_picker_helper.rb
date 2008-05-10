module ColorPickerHelper
  def color_picker options={}
    options = options.merge(
      {
        :name  => 'cp1',
        :color => 'ff0000'
      }
    ).merge(options)
    render :partial => 'shared/color_picker', :locals => { :options => options }
  end
end
