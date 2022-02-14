Rails.application.routes.draw do
    get "/cards", to: "cards#index"
end
