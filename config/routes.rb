Rails.application.routes.draw do
  root 'status#index'

  resource 'status', controller: 'status'
end
