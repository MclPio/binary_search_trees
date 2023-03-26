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

  def build_tree(array = self.array, start_idx = 0, end_idx = array.length - 1)
    return nil if start_idx > end_idx

    mid = (start_idx + end_idx) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start_idx, mid - 1)
    root.right = build_tree(array, mid + 1, end_idx)
    self.root = root
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(root, value)
    root = Node.new(value) if root.nil?

    if value < root.data
      root.left = insert(root.left, value)
    elsif value > root.data
      root.right = insert(root.right, value)
    end
    root
  end

  def delete
  end
end


# Tests
arr = Array.new(11) { |ele| ele + 1}
tree = Tree.new(arr)
tree.build_tree
# tree.insert(tree.root, 15)
# tree.insert(tree.root, -16)
# tree.insert(tree.root, 22)
# tree.insert(tree.root, -2)
tree.pretty_print