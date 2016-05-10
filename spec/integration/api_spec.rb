describe App::API do
  include Rack::Test::Methods

  def app
    App::API
  end
  before :all do
    App::Cab.recreate_index!
  end

  context 'GET /api/v1/cabs/eta' do
    it 'without params returns error' do
      get '/api/v1/cabs/eta'
      expect(response_json['error']).to eq('lat is missing')
      get '/api/v1/cabs/eta?lat=example'
      expect(response_json['error']).to eq('lon is missing')
    end
    it 'with no cabs returns default eta' do
      get '/api/v1/cabs/eta?lat=55.662987&lon=37.656230'
      expect(response_json['eta']).to eq('so_far_so_good')
    end
    it 'with cabs shout return eta' do
      load_data
      get '/api/v1/cabs/eta?lat=0.00369126&lon=0.01984175'
      expect(response_json['eta']).to eq(0)
      get '/api/v1/cabs/eta?lat=0.01369126&lon=0.02984175'
      expect(response_json['eta']).to eq(0.14960822542313618)
    end
  end
end