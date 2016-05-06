module App
  module Cab
    module_function

    def eta_for(lat, lon)
      distances = nearest(lat, lon).dig('hits', 'hits').map{|hit|hit['sort'].first.to_f}
      return settings.default_eta if distances.empty?
      (distances.inject(:+) / distances.size) * settings.eta_modifier
    end
    def nearest(lat, lon)
      connection.search index: settings.index_name, type: settings.index_type, body: nearest_query(lat, lon)
    end

    def nearest_query(lat, lon)
      {
          size: settings.cab_size,
          query: {
              filtered: {
                  query: {
                      match: {
                          vacant: true
                      }
                  },
                  filter: {
                      geo_distance: {
                          distance: settings.distance,
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
      }
    end
    def mappings
      {
          cab: {
              properties: {
                  location: {
                      type: :geo_point
                  },
                  vacant: {
                      type: :boolean
                  }
              }
          }
      }
    end

    def recreate_index!
      indices.delete index: settings.index_name if index_exists?
      indices.create index: settings.index_name, body: { mappings: mappings }
    end
    def index_exists?
      indices.exists(index: settings.index_name) rescue false
    end
    def indices
      connection.indices
    end

    def connection
      @connection ||= Elasticsearch::Client.new
    end
    def settings
      @settings ||= Settings.cab
    end
  end
end