# frozen_string_literal: true

task default: [:install]

desc 'Clean.'
task :clean do
  `rm -f *.gem`
end

desc 'Build gems.'
task gem: [:clean] do
  `gem build store_put_get-dynamodb.gemspec`
end

desc 'Build and install gems.'
task install: [:gem] do
  `gem install *.gem`
end

desc 'Test.'
task test: %i[storeputget dynamodb]

desc 'Test StorePutGet class'
task :storeputget do
  sh './runtest.sh storeputgetbase'
end

desc 'Test DynamoDB'
task dynamodb: %i[start_dynamodb test_dynamodb_internal stop_dynamodb]

$dbaddress = nil

desc 'Start local DynamoDB'
task :start_dynamodb do
  $dbaddress = `./dynamodb.sh 1`
end

desc 'Run DynamoDB test using running instance'
task test_dynamodb_internal: %i[start_dynamodb] do
  sh "./runtest.sh dynamodb #{$dbaddress}"
end

desc 'Stop local DynamoDB'
task :stop_dynamodb do
  sh './dynamodb.sh 0'
end
