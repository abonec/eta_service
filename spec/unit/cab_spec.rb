describe App::Cab do
  before :all do
    App::Cab.recreate_index!
    App::Cab.put_settings 'index.refresh_interval': -1
    App::Cab.refresh
  end

  it 'with zero count' do
    expect(App::Cab.count).to eq(0)
  end

  it 'create document' do
    expect do
      @id = App::Cab.create(location: 'ucfu8vhkm', vacant: true)
      App::Cab.refresh
    end.to change(App::Cab, :count).by(1)
  end

end