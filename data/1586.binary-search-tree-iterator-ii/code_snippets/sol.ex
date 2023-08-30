# Definition for a binary tree node.
#
# defmodule TreeNode do
#   @type t :: %__MODULE__{
#           val: integer,
#           left: TreeNode.t() | nil,
#           right: TreeNode.t() | nil
#         }
#   defstruct val: 0, left: nil, right: nil
# end

defmodule BSTIterator do
  @spec init_(root :: TreeNode.t | nil) :: any
  def init_(root) do

  end

  @spec has_next() :: boolean
  def has_next() do

  end

  @spec next() :: integer
  def next() do

  end

  @spec has_prev() :: boolean
  def has_prev() do

  end

  @spec prev() :: integer
  def prev() do

  end
end

# Your functions will be called as such:
# BSTIterator.init_(root)
# param_1 = BSTIterator.has_next()
# param_2 = BSTIterator.next()
# param_3 = BSTIterator.has_prev()
# param_4 = BSTIterator.prev()

# BSTIterator.init_ will be called before every test case, in which you can do some necessary initializations.