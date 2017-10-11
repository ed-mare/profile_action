Rails.application.routes.draw do
  mount ProfileAction::Engine => '/profile_action'
end
