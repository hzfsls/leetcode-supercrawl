defmodule FileSharing do
  @spec init_(m :: integer) :: any
  def init_(m) do

  end

  @spec join(owned_chunks :: [integer]) :: integer
  def join(owned_chunks) do

  end

  @spec leave(user_id :: integer) :: any
  def leave(user_id) do

  end

  @spec request(user_id :: integer, chunk_id :: integer) :: [integer]
  def request(user_id, chunk_id) do

  end
end

# Your functions will be called as such:
# FileSharing.init_(m)
# param_1 = FileSharing.join(owned_chunks)
# FileSharing.leave(user_id)
# param_3 = FileSharing.request(user_id, chunk_id)

# FileSharing.init_ will be called before every test case, in which you can do some necessary initializations.