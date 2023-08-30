defmodule SQL do
  @spec init_(names :: [String.t], columns :: [integer]) :: any
  def init_(names, columns) do

  end

  @spec insert_row(name :: String.t, row :: [String.t]) :: any
  def insert_row(name, row) do

  end

  @spec delete_row(name :: String.t, row_id :: integer) :: any
  def delete_row(name, row_id) do

  end

  @spec select_cell(name :: String.t, row_id :: integer, column_id :: integer) :: String.t
  def select_cell(name, row_id, column_id) do

  end
end

# Your functions will be called as such:
# SQL.init_(names, columns)
# SQL.insert_row(name, row)
# SQL.delete_row(name, row_id)
# param_3 = SQL.select_cell(name, row_id, column_id)

# SQL.init_ will be called before every test case, in which you can do some necessary initializations.