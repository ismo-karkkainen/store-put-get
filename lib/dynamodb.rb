# frozen_string_literal: true

require_relative './storeputgetbase.rb'
require 'aws-sdk-dynamodb'

module StorePutGet

  class DynamoDB < StorePutGetBase
    private
    attr_accessor :client
    public

    def initialize(table_name, field_name, client_options = {})
      super(table_name, field_name)
      @client = Aws::DynamoDB::Client.new(client_options)
      t = @client.describe_table(table_name: @table_name).table

      # Is field_name primary_key?
      # Which secondary index holds the key? Store the info for queries.
      # Also what is the actual primary key?
    end
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/DynamoDB/Client.html

    def put(item)
      super(item)
    end

    def get(id)
      super(id)
      # If secondary index, get item and it's primary key unless full item.
      # Figure out new id if need be.
      r = @client.get_item({
        table_name: @table_name,
        key: id,
        return_comsumed_capacity: 'NONE',
        consistent_read: false
      })
      r.item
    end
  end

end
