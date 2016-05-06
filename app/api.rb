module App
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    resource :cabs do
      desc 'return eta for location'
      params do
        requires :lat, :lon
      end
      get :eta do
        {eta: Cab.eta_for(params[:lat], params[:lon])}
      end
    end
  end
end