Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: proc { [ 200, { "Content-Type" => "application/json" }, [ '{"health": "ok"}' ] ] }

  # authentication
  post  "login" => "authentication#login"
  get   "auth"  => "authentication#auth"
end
