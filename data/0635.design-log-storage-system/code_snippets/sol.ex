defmodule LogSystem do
  @spec init_() :: any
  def init_() do

  end

  @spec put(id :: integer, timestamp :: String.t) :: any
  def put(id, timestamp) do

  end

  @spec retrieve(start :: String.t, end :: String.t, granularity :: String.t) :: [integer]
  def retrieve(start, end, granularity) do

  end
end

# Your functions will be called as such:
# LogSystem.init_()
# LogSystem.put(id, timestamp)
# param_2 = LogSystem.retrieve(start, end, granularity)

# LogSystem.init_ will be called before every test case, in which you can do some necessary initializations.