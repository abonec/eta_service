module App
  class Cab
    include ActiveModel::Model
    include Elasticsearch::Model

    attr_accessor :location, :vacant, :id
    index_name 'cabs'
    settings number_of_shards: 1 do
      mappings do
        indexes :location, type: :geo_point
        indexes :vacant, type: :boolean
      end
    end

    def as_json(*)
      { vacant: vacant, location: location }
    end
  end
end