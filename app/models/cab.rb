require 'app/models/cab/migration'
module App
  module Cab
    extend Migration
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
          bool: {
            must: {
              term: {
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

    def create(location:, vacant:)
      connection.create(index: settings.index_name, type: settings.index_type, body: {
        location: location,
        vacant: vacant,
      })['_id']
    end
    def count
      connection.count(index: settings.index_name)['count']
    end
    def connection
      @connection ||= Elasticsearch::Client.new
    end
    def settings
      @settings ||= Settings.cab
    end
  end
end
