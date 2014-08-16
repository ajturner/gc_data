## ElasticSearch

You need to install and serve ElasticSearch from `localhost:9200` for now. This will be configurable in the future.

## Load GeoCommons data into ElasticSearch

```bash
gem install elasticsearch
ruby index.rb
```

### Verify data loaded

To see that you have data, visit http://localhost:9200/features/_search


