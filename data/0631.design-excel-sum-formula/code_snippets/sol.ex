defmodule Excel do
  @spec init_(height :: integer, width :: char) :: any
  def init_(height, width) do

  end

  @spec set(row :: integer, column :: char, val :: integer) :: any
  def set(row, column, val) do

  end

  @spec get(row :: integer, column :: char) :: integer
  def get(row, column) do

  end

  @spec sum(row :: integer, column :: char, numbers :: [String.t]) :: integer
  def sum(row, column, numbers) do

  end
end

# Your functions will be called as such:
# Excel.init_(height, width)
# Excel.set(row, column, val)
# param_2 = Excel.get(row, column)
# param_3 = Excel.sum(row, column, numbers)

# Excel.init_ will be called before every test case, in which you can do some necessary initializations.