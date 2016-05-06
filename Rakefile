task :environment do
  require_relative 'app'
end
desc 'Print api routes'
task routes: :environment do
  mapping = method_mapping

  grape_klasses = ObjectSpace.each_object(Class).select { |klass| klass < Grape::API }
  routes = grape_klasses.
      flat_map(&:routes).
      uniq { |r| r.send(mapping[:path]) + r.send(mapping[:method]).to_s }

  method_width, path_width, version_width, desc_width = widths(routes, mapping)

  routes.each do |api|
    method = api.send(mapping[:method]).to_s.rjust(method_width)
    path = api.send(mapping[:path]).to_s.ljust(path_width)
    version = api.send(mapping[:version]).to_s.ljust(version_width)
    desc = api.send(mapping[:description]).to_s.ljust(desc_width)
    puts "     #{method}  |  #{path}  |  #{version}  |  #{desc}"
  end
end

desc 'recreate index'
task recreate_index: :environment do
  App::Cab.__elasticsearch__.create_index! force: true
  App::Cab.__elasticsearch__.refresh_index!
end
namespace :recreate_index do
  desc 'recreate index with data'
  task with_data: :recreate_index do
    vacant = [true,false]
    File.readlines('cabs.txt').map(&:strip).each do |location|
      App::Cab.new(vacant: vacant.sample, location: location).__elasticsearch__.index_document
    end
  end
end

def widths(routes, mapping)
  [
      routes.map { |r| r.send(mapping[:method]).try(:length) }.compact.max || 0,
      routes.map { |r| r.send(mapping[:path]).try(:length) }.compact.max || 0,
      routes.map { |r| r.send(mapping[:version]).try(:length) }.compact.max || 0,
      routes.map { |r| r.send(mapping[:description]).try(:length) }.compact.max || 0
  ]
end

def method_mapping
  if Gem.loaded_specs['grape'].version.to_s >= "0.15.1"
    {
        method: 'request_method',
        path: 'path',
        version: 'version',
        description: 'description'
    }
  else
    {
        method: 'route_method',
        path: 'route_path',
        version: 'route_version',
        description: 'route_description'
    }
  end
end
