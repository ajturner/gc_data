#!/usr/bin/env ruby

require 'elasticsearch'
require 'json'

client = Elasticsearch::Client.new log: true
client.transport.reload_connections!
client.cluster.health

mapping = {
  feature: {
    properties: {
         geometry: {
             type: "geo_shape",
             tree: "quadtree",
             precision: "1m"
         }
    }
  }
}

body = {mappings: mapping}
client.indices.create index: 'features', body: body
# put_mapping index: 'features', type: 'feature', body: mapping

Dir.glob('*.geojson').each do |file|
  json = JSON.parse(File.open(file).read)
  features = json.delete("features")
  client.index  index: 'datasets', type: 'dataset', id: json["id"], body: json
  features.each_with_index do |feature,i|
    begin
      client.index  index: 'features', type: 'feature', id: [json["id"],i].join(':'), body: {properties: feature['properties'].to_s, geometry: feature['geometry']}
    rescue Exception => e
      puts "Failed on #{i}"
      next
    end
  end

end
