# frozen_string_literal: true

require_relative './storeputgetbase.rb'
require 'aws-sdk-dynamodb'

module StorePutGet

  class DynamoDb < StorePutGetBase
    private

    attr_accessor :client, :kind, :index, :pri

    def primary(key_schemas)
      key_schemas.each do |ks|
        return true if ks.fetch(:attribute_name, '') == @field
      end
      false
    end

    def secondary(indexes)
      indexes.each do |idx|
        next unless primary(idx.fetch(:key_schema, []))
        @index = idx.fetch(:index_name, nil)
        return true
      end
      false
    end

    public

    def initialize(table_name, field_name, client_options = {})
      super(table_name, field_name)
      @index = nil
      @pri = nil
      @client = Aws::DynamoDB::Client.new(client_options)
      t = @client.describe_table(table_name: @table).table
      puts t
      if primary(t.fetch(:key_schema, []))
        @kind = :primary
      elsif secondary(t.fetch(:local_secondary_indexes, []))
        @kind = :local
      elsif secondary(t.fetch(:global_secondary_indexes, []))
        @kind = :secondary
      else
        raise ArgumentError, "No index with key #{@field}."
      end
      unless @kind == :primary
        @pri = t.fetch(:key_schema, []).first.fetch(:attribute_name, '')
      end
    end
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/DynamoDB/Client.html

    def put(item)
      super(item)
      @client.put_item({
        item: item,
        return_consumed_capacity: 'NONE',
        return_values: 'NONE',
        table_name: @table
      })
    end

    def get(id)
      super(id)
      unless @kind == :primary
        r = @client.query({
          table_name: @table,
          index_name: @support[:index],
          select: 'ALL_ATTRIBUTES',
          key_condition_expression: '#n = :v',
          expression_attribute_names: { '#n' => @field },
          expression_attribute_values: { ':v' => id }
        })
        return nil if r.items.empty?
        id = r.items.first.fetch(@pri, nil)
      end
      if @kind == :local
        return r.items.first
      end
      r = @client.get_item({
        table_name: @table,
        key: { @pri => id },
        return_comsumed_capacity: 'NONE',
        consistent_read: false
      })
      r.item
    end

    def delete(id)
      super(id)
      unless @kind == :primary
        item = get(id)
        id = item.fetch(@pri, nil)
      end
      r = @client.delete_item({
        table_name: @table,
        key: { @pri => id },
        return_comsumed_capacity: 'NONE',
        return_values: 'NONE'
      })
    end
  end

end
