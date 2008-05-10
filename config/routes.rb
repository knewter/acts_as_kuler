ActionController::Routing::Routes.draw do |map|
  map.resources :themes, :has_many => [:colors]
  map.connect '', :controller => :themes
end
