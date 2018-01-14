Rails.application.routes.draw do
  root to: 'router#route'
  get '*path', to: 'router#route'
end
