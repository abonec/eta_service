module App
  class Cab
    DISTANCE = '15km'
    CAB_SIZE = 3
    ETA_MODIFIER = 1.5
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

    class << self
      def eta_for(lat, lon)
        distances = nearest(lat, lon).response.dig('hits', 'hits').map{|hit|hit['sort'].first.to_f}
        (distances.inject(:+) / distances.size) * ETA_MODIFIER
      end
      def nearest(lat, lon)
        search({
                   size: CAB_SIZE,
                   query: {
                       filtered: {
                           query: {
                               match: {
                                   vacant: true
                               }
                           },
                           filter: {
                               geo_distance: {
                                   distance: DISTANCE,
                                   location: {
                                       lat: lat,
                                       lon: lon
                                   }
                               }
                           }
                       }
                   },
                   sort: [
                       {
                           _geo_distance: {
                               location: {
                                   lat:  lat,
                                   lon: lon
                               },
                               order:         :asc,
                               unit:          :km,
                               distance_type: :sloppy_arc
                           }
                       }
                   ]
               })
      end
    end
  end
end