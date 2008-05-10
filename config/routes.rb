ActionController::Routing::Routes.draw do |map|
  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete }

  map.signup '/signup', :controller => 'users',    :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resource :session

  map.resources :themes, :has_many => [:colors], :member => [:copy]
  map.connect '', :controller => 'themes'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
end
