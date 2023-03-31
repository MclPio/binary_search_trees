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

  # accepts value and returns Node object with given value, else nil
  def find(value, root = @root)
    return nil if root.nil?

    if value < root.data
      find(value, root.left)
    elsif value > root.data
      find(value, root.right)
    elsif value == root.data
      root
    end
  end

  # breadth-first level order. accepts a block. Without block, returns array
  def level_order
    current_node = root
    q = []
    q << current_node
    result = []
    while !q.empty?
      temp_node = q[0]
      yield temp_node.data if block_given?
      result << temp_node.data
      if !temp_node.left.nil?
        q << temp_node.left
      end
      if !temp_node.right.nil?
        q << temp_node.right
      end
      q.shift
    end
    result if !block_given?
  end

  # left, root, right traversal, no block returns an array
  def inorder(root = @root)
    result = []

    traversal = lambda do |node|
      return if node.nil?

      traversal.call(node.left)
      result << node.data
      yield node.data if block_given?
      traversal.call(node.right)
    end
    traversal.call(root)
    result unless block_given?
  end

  # left, root, right traversal, no block returns an array
  def inorder_iterative(root = @root)
    result = []
    stack = []
    current = root
    until current.nil? && stack.empty?
      until current.nil?
        stack << current
        current = current.left
      end
      current = stack.pop
      yield current.data if block_given?
      result << current.data
      current = current.right
    end
    result unless block_given?
  end

  # root, left, right, no block returns array
  def preorder(root = @root)
    result = []

    traversal = lambda do |node|
      return if node.nil?

      result << node.data
      yield node.data if block_given?
      traversal.call(node.left)
      traversal.call(node.right)
    end
    traversal.call(root)
    result unless block_given?
  end

  #left, right, root, no block returns an array
  def postorder(root = @root)
    result = []

    traversal = lambda do |node|
      return if node.nil?

      traversal.call(node.left)
      traversal.call(node.right)
      yield node.data if block_given?
      result << node.data
    end
    traversal.call(root)
    result unless block_given?
  end

  def height(root = @root)
    return 0 if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)

    [left_height, right_height].max + 1
  end

  def depth(value, root = @root)
    depth = 0
    return nil if root.nil?

    inner = lambda do |val, node|
      depth += 1
      if val < node.data
        inner.call(val, node.left)
      elsif val > node.data
        inner.call(val, node.right)
      elsif val == node.data
        node
      end
    end
    inner.call(value, root)
    depth
  end

  def balanced?(node = @root)
    return 0 if node.nil?

    left_height = balanced?(node.left)
    return -1 if left_height == -1

    right_height = balanced?(node.right)
    return -1 if right_height == -1

    return -1 if (left_height - right_height).abs > 1

    return [left_height, right_height].max + 1
  end

  def rebalance
    build_tree(inorder(@root))
  end
end

# Driver Script

# Array.new(15) { rand(1..100)}).sort.uniq
arr = [7, 14, 15, 19, 21, 24, 29, 41, 52, 57, 69, 70, 80, 98]
tree = Tree.new(arr)
tree.build_tree
p tree.balanced?
puts "level_order: #{tree.level_order} \npre_order: #{tree.preorder} \npost_order: #{tree.postorder} \nin_order: #{tree.inorder}"
tree.insert(tree.root, 101)
tree.insert(tree.root, 102)
tree.insert(tree.root, 103)
tree.insert(tree.root, 104)
tree.insert(tree.root, 105)
p tree.balanced?
tree.rebalance
p tree.balanced?
puts "level_order: #{tree.level_order} \npre_order: #{tree.preorder} \npost_order: #{tree.postorder} \nin_order: #{tree.inorder}"
tree.pretty_print
