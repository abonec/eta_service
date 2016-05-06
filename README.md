# eta_service

## Explanation

All calculation about distance and selecting cab executed on elasticsearch node. Ruby just calculate ETA based on distance which was precalculated by elasticsearch using haversine formula.

## Further development

* replace lat&lon by geohash precalculated by client
* enable caching based on reduced dimension of given geohash

## Requirements

* Ruby 2.3
* [Elasticsearch 2.3.2](https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html)

## Run

* `bundle install`
* `rackup`

## Add fake cabs

* `rake recreate_index:with_data[cabs_num]`

***cabs_num*** is up to 100000 (default = 100_000)

## Routes

* `rake routes`

## Console

* `pry`

## Benchmark

* `gem install puma`
* install apache benchmark
* `puma -p3000`
* `ab -n 1000 -c 2 http://localhost:3000/api/v1/cabs/eta\?lat\=55.662987\&lon\=37.656235`

On i5-2410M laptop with 100_000 cabs in base:

<pre>Concurrency Level:      2
Time taken for tests:   2.607 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      97000 bytes
HTML transferred:       26000 bytes
Requests per second:    383.64 [#/sec] (mean)
Time per request:       5.213 [ms] (mean)
Time per request:       2.607 [ms] (mean, across all concurrent requests)
Transfer rate:          36.34 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     4    5   1.1      5      17
Waiting:        4    5   1.1      5      17
Total:          4    5   1.1      5      17

Percentage of the requests served within a certain time (ms)
  50%      5
  66%      5
  75%      5
  80%      5
  90%      6
  95%      7
  98%      8
  99%     10
 100%     17 (longest request)</pre>
