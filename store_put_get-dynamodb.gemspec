Gem::Specification.new do |s|
  s.name        = 'store_put_get-dynamodb'
  s.version     = '0.0.1'
  s.date        = '2021-10-19'
  s.summary     = "Simple put/get functionality for DynamoDB."
  s.description = %q(
Simple put/get functionality to get a record into and out of DynamoDB.
)
  s.authors     = [ 'Ismo Kärkkäinen' ]
  s.email       = 'ismokarkkainen@icloud.com'
  s.files       = [ 'lib/storeputgetbase.rb', 'lib/dynamodb.rb', 'LICENSE.txt' ]
  s.homepage    = 'https://xn--ismo-krkkinen-gfbd.fi/store-put-get/index.html'
  s.license     = 'UPL-1.0'
  s.add_runtime_dependency 'aws-sdk-dynamodb', '~> 1.64', '>= 1.64.0'
end

