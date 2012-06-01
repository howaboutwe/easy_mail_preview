EasyMailPreview::Engine.routes.draw do
  root :to => 'emails#index'
  match "/emails/show/:id" => "emails#show"
end
