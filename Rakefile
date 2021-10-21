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
task :dynamodb do
  
end

