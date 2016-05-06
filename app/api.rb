module App
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    resource :cabs do
      desc 'return eta for location'
      get :eta do
        {result: :ok}
      end
    end
  end
end