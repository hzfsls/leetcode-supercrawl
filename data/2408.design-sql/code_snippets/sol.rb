class SQL

=begin
    :type names: String[]
    :type columns: Integer[]
=end
    def initialize(names, columns)

    end


=begin
    :type name: String
    :type row: String[]
    :rtype: Void
=end
    def insert_row(name, row)

    end


=begin
    :type name: String
    :type row_id: Integer
    :rtype: Void
=end
    def delete_row(name, row_id)

    end


=begin
    :type name: String
    :type row_id: Integer
    :type column_id: Integer
    :rtype: String
=end
    def select_cell(name, row_id, column_id)

    end


end

# Your SQL object will be instantiated and called as such:
# obj = SQL.new(names, columns)
# obj.insert_row(name, row)
# obj.delete_row(name, row_id)
# param_3 = obj.select_cell(name, row_id, column_id)