# frozen_string_literal: true

class StorePutGet
  attr_reader :table, :field

  def initialize(table_name, field_name)
    @table = table_name
    @field = field_name
  end

  def put(item)
    raise ArgumentError, "No #{@field} in item." unless item.has_key? @field
  end

  def get(id)
    raise ArgumentError, "No id." if id.nil?
  end
end
