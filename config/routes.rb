Rails.application.routes.draw do
  get  :locales, to: 'locales#download'
  post :locales, to: 'locales#upload'
end
