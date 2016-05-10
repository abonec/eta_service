require 'active_support/core_ext/array/grouping'
module App
  module Cab
    module Migration
      def load_data(file, limit=0)
        locations = File.readlines(file).map(&:strip)
        locations = locations.first(limit) unless limit.zero?

        locations.in_groups_of(settings.import_batch_size, false) do |locations_batch|
          index_bulk = locations_batch.map do |location|
            [
                {index: {_index: settings.index_name, _type: settings.index_type}},
                {vacant: true, location: location}
            ]
          end.flatten
          connection.bulk body: index_bulk
        end
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
      def refresh
        indices.refresh
      end

      def put_settings(es_settings)
        indices.put_settings index: @settings.index_name, body: es_settings
      end
    end
  end
end