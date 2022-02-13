Rails.application.routes.draw do
    get "/cards", to: "cards#index"
    get "/sets", to: "cards#get_sets"
end
