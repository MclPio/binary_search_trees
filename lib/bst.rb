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

  def minValueNode(node)
    current = node
    while(!current.left.nil?)
      current = current.left
    end
    current
  end

  def delete(value, root = @root)
    return root if root.nil?

    if value < root.data
      root.left = delete(value, root.left)
    elsif value > root.data
      root.right = delete(value, root.right)
    else
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      elsif root.right.nil?
        temp = root.left
        root = nil
        return temp
      end
      temp = minValueNode(root.right)
      root.data = temp.data
      root.right = delete(temp.data, root.right)
    end
    root
  end
end


# Tests
arr = Array.new(11) { |ele| ele + 1}
tree = Tree.new(arr)
tree.build_tree
tree.insert(tree.root, 15)
tree.insert(tree.root, -16)
tree.insert(tree.root, 22)
tree.insert(tree.root, -2)
tree.delete(6)
tree.delete(9)
tree.pretty_print
