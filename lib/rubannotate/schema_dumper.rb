# frozen_string_literal: true

module Rubannotate
  class SchemaDumper
    HEADER = '# == Schema Information'

    def initialize(table_name, connection)
      @table_name = table_name
      @connection = connection
    end

    def dump(stream = STDOUT)
      dump_header(stream)
      dump_columns(stream)
      dump_indexes(stream)
      dump_foreign_keys(stream)
      dump_trailer(stream)

      stream
    end

    private

    def dump_header(stream)
      stream.puts HEADER
      stream.puts '#'
    end

    def dump_columns(stream)
      stream.puts "# Table name: #{@table_name}"
      stream.puts '#'

      columns = @connection.columns(@table_name)
      return unless columns.any?

      table = columns.map { |column| build_column_column_cells(column) }
      merge_column_cells(table).each { |row| stream.puts "#  #{row}" }
      stream.puts '#'
    end

    def dump_indexes(stream)
      indexes = @connection.indexes(@table_name)
      return unless indexes.any?

      stream.puts '# Indexes'
      stream.puts '#'

      table = indexes.map { |index| build_index_column_cells(index) }
      merge_column_cells(table).sort.each { |row| stream.puts "#  #{row}" }
      stream.puts '#'
    end

    def dump_foreign_keys(stream)
      foreign_keys = @connection.foreign_keys(@table_name)
      return unless foreign_keys.any?

      stream.puts '# Foreign Keys'
      stream.puts '#'

      table = foreign_keys.map { |fk| build_foreign_key_column_cells(fk) }
      merge_column_cells(table).sort.each { |row| stream.puts "#  #{row}" }
      stream.puts '#'
    end

    def dump_trailer(stream); end

    def build_column_column_cells(column)
      r = []

      name_info = column.name
      name_info += "(#{column.comment})" if column.comment
      r << name_info

      type_info = ":#{column.type}"
      type_info += "(#{column.limit})" if column.limit
      type_info += "(#{column.precision},#{column.scale})" if column.precision && column.scale
      r << type_info

      attrs = []
      attrs << "default(#{column.default})" unless column.default.nil?
      attrs << 'not null' unless column.null
      attrs << 'primary key' if @connection.primary_keys(@table_name).include?(column.name)
      attrs_info = attrs.join(', ')
      r << attrs_info

      r
    end

    def build_index_column_cells(index)
      r = []

      name_info = index.name
      r << name_info

      columns_info = index.columns.is_a?(Array) ? "(#{index.columns.join(',')})" : index.columns
      columns_info += ' UNIQUE' if index.unique
      r << columns_info

      r
    end

    def build_foreign_key_column_cells(foreign_key)
      r = []

      name_info = foreign_key.name.to_s.starts_with?('fk_rails_') ? 'fk_rails_...' : foreign_key.name
      r << name_info if name_info

      reference_info = "(#{foreign_key.column} => #{foreign_key.to_table}.#{foreign_key.primary_key})"
      r << reference_info

      r
    end

    def merge_column_cells(table)
      max_widths = Array.new(table[0].size, 0)
      widths = table.map.with_index do |row, _x|
        row.map.with_index do |cell, y|
          width = cell.chars.map do |char|
            char.bytesize == 1 ? 1 : 2
          end.reduce(:+) || 0

          max_width = max_widths[y]
          max_widths[y] = width if max_width < width
          width
        end
      end

      table.map.with_index do |row, x|
        r = ''
        row.map.with_index do |cell, y|
          padding = ' ' * (max_widths[y] - widths[x][y] + 2)
          r += cell + padding
        end
        r.strip
      end
    end
  end
end
