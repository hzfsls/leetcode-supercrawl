defmodule FileSystem do
  @spec init_() :: any
  def init_() do

  end

  @spec ls(path :: String.t) :: [String.t]
  def ls(path) do

  end

  @spec mkdir(path :: String.t) :: any
  def mkdir(path) do

  end

  @spec add_content_to_file(file_path :: String.t, content :: String.t) :: any
  def add_content_to_file(file_path, content) do

  end

  @spec read_content_from_file(file_path :: String.t) :: String.t
  def read_content_from_file(file_path) do

  end
end

# Your functions will be called as such:
# FileSystem.init_()
# param_1 = FileSystem.ls(path)
# FileSystem.mkdir(path)
# FileSystem.add_content_to_file(file_path, content)
# param_4 = FileSystem.read_content_from_file(file_path)

# FileSystem.init_ will be called before every test case, in which you can do some necessary initializations.