load_files = %W{
  action_controller_extensions
  action_view_helper_extensions 
}.each do |load_file|
  require File.join('isotope11', load_file)
end
