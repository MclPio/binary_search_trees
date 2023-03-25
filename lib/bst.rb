class Node
  attr_reader :data

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

arr = Array.new(4) { |idx| idx+1}
a = Node.new(arr)
b = Node.new(arr.map { |ele| ele+2})
p a < b
