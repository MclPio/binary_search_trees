class Node 
  attr_accessor :data, :left, :right

  include Comparable

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :array

  def initialize(array)
    @array = array.uniq.sort
  end

  def build_tree(array = @array, start_idx = 0, end_idx = array.length - 1)
    return nil if start_idx > end_idx

    mid = (start_idx + end_idx) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start_idx, mid - 1)
    root.right = build_tree(array, mid + 1, end_idx)
    root
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end


# Tests
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
a = Node.new(arr)
b = Node.new(arr.map { |ele| ele+2})
a < b
tree = Tree.new(arr)
root = tree.build_tree
p root
tree.root = root
tree.pretty_print
