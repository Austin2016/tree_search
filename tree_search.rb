#[1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
#[1,2,3,4,5] => 3,2,5,1,4 level order
class Node
  
  include Comparable 
  attr_accessor :value, :left, :right

  def <=>(other_node_value)
        @value<=>other_node_value
  end 

  def initialize(value,left=nil,right=nil) 
    @value = value
    @left = left
    @right = right  
  end  

end

class Tree 
  
  attr_accessor :root 

  def initialize (array)
    sorted_array = array.uniq.sort 
    @root= self.build_tree(sorted_array) 
  end 

  def build_tree (sorted_array)
    if sorted_array.length == 0 
    	return nil 
    end 
    middle_index = sorted_array.length / 2
    left = build_tree( sorted_array.slice(0,middle_index) )
    right = build_tree( sorted_array.slice(middle_index + 1,sorted_array.length) )
    Node.new( sorted_array[middle_index],left,right )
  end 
 
  def insert(value,node)
  	if node == nil 
  	  return nil 
  	end 
    if value < node.value
      if node.left == nil   
        node.left = Node.new(value, nil, nil) 
      else 
        insert(value,node.left)
      end 
    elsif value > node.value
      if node.right == nil
        node.right = Node.new(value, nil, nil) 
      else 
        insert(value,node.right) 
      end 
    elsif value == node.value 
      return nil
    end  
  end 

  def find(value=nil,node=nil)
    if node == nil 
      return nil 
    end  
    if node.<=>(value) == 1
      self.find(value,node.left)
    elsif node.<=>(value) == -1 
      self.find(value,node.right)
    else 
      return node
    end 
  end


  def delete(value,node)           
    if node == nil 
      return nil 
    end
    if node.<=>(value) == 1                    
      node.left = self.delete(value,node.left)
      return node
    elsif node.<=>(value) == - 1
      node.right = self.delete(value,node.right)
      return node
    else 
      if node.left == nil && node.right == nil
        return nil   
      elsif node.left == nil 
        return node.right
      elsif node.right == nil
        return node.left
      else
        if node.right.left == nil
          node.value = node.right.value  
          node.right = self.delete(node.right.value, node.right) 
        else  
          current = node.right 
          while current.left.left != nil 
            current = current.left
          end
          node.value = current.left.value 
          current.left = self.delete(current.left.value,current.left)
        end
        return node   
      end 
    end 
  end 

  def count(node)
    if node == nil 
      return 0
    else
      return self.count(node.right) + self.count(node.left) + 1 
    end 
  end   

  def verify(array)
  	array = array.uniq.sort 
    result = true
    if array.length != self.count(self.root)
     result = false  
    end 
    array.any? { |e| result = false if self.find(e,self.root) == nil }
    result 
  end 
  
  def tree_values(node)
    if node == nil 
      return [] 
    else 
      return tree_values(node.left) + [node.value] + tree_values(node.right)
    end 
  end 
  
  def level_order(node)
    return nil if node == nil
        
    current = node
    queue = []
    array =[] 
    queue << current
    while current != nil 
      queue << current.left if current.left != nil 
      queue << current.right if current.right != nil 
      if block_given? 
        yield( queue.slice!(0) )
      else 
        array << queue.slice!(0).value
      end
      current = queue[0] 
    end
    print array if block_given? == false
    puts ""
    return array if block_given? == false 
  end 

   def recursive_level_order
     level = 0
     while print_ith_level(@root,level)
       level+=1 
     end
   end

  def print_ith_level(node,level)
    if node == nil || level < 0
      return false 
    end 

    if level == 0
      puts node.value
      return true
    else 
      left = print_ith_level(node.left,level - 1 )
      right = print_ith_level(node.right,level - 1)
      return left || right 
    end 
  end

  def depth(node)
    if node == nil 
      return 0
    end 
    left = depth(node.left)
    right = depth(node.right)
    
    left > right ? left + 1  : right + 1  
  end

  def balanced?(node)
    difference = depth(node.left) - depth(node.right)
    difference *= -1 if difference < 0
    if node == nil 
      return nil
    elsif difference <= 1  
      return true
    else  
      return false 
    end 
  end
  
  def rebalance!
    array = self.tree_values(self.root)
    array = array.uniq.sort
    self.root = self.build_tree(array)
  end 




  def pre_order(node)
    if node == nil 
      return false 
    end 

    if block_given?
      yield (node.value)
    end
    pre_order(node.left) {|e| puts e}
    pre_order(node.right) {|e| puts e}

  end

  def in_order(node)
    if node == nil 
      return false 
    end 

    

    in_order(node.left) {|e| puts e}
    if block_given? 
      yield (node.value)
    end 
    in_order(node.right) {|e| puts e}

  end

  def post_order(node)
    if node == nil 
      return false
    end 

    post_order(node.left) {|e| puts e}
    post_order(node.right) {|e| puts e}
    if block_given? 
      yield (node.value) 
    end 

  end


end  

class Test

  MAX_ARRAY_LENGTH = 100

  def self.loop_run(number)
    array = []
    number.times { array << self.run}
    puts "all good" if array.all?
    puts "failed" if !array.all?   
  end 



  def self.run 
    array = get_random_array
  
    tree = Tree.new(array)
    
  
    for i in 0..rand(1..100)
      coin_flip = 'heads' if rand(2) == 1
   
      if coin_flip == 'heads'
        random_index = rand(array.length).floor 
        tree.root = tree.delete(array[random_index], tree.root)
        array.slice!(random_index) if array != [] 
      else 
        random_integer = rand(1000) 
        tree.insert(random_integer,tree.root)
        if array.all? {|e| e != random_integer} && array != [] 
          array << random_integer 
        end 
      end 
    end   
    result = tree.verify(array)

  end 

  def self.get_random_array
    length = rand(MAX_ARRAY_LENGTH + 1) 
    array = Array.new(length)
    for i in 0..array.length - 1 
      array[i] = rand(length)
    end 
    array.uniq.sort
  end 
end

=begin
#Test.run
#Test.loop_run(10000)         # run test 10k times 
my_tree = Tree.new([1])
#my_tree = Tree.new(['a','b','c','d','e','f','g','i','j','k'])
#my_tree.level_order(my_tree.root) {|e|  puts e.value}
#my_tree.in_order(my_tree.root) {|e| puts e}
#puts my_tree.balanced?(my_tree.root)
my_tree.insert(2,my_tree.root)
my_tree.insert(3,my_tree.root)
my_tree.insert(4,my_tree.root)
my_tree.insert(5,my_tree.root)
puts my_tree.balanced?(my_tree.root)
puts my_tree.root.value 
my_tree.rebalance! 
puts my_tree.root.value
puts my_tree.balanced?(my_tree.root) 
=end 

array = Array.new(15) { rand(1..100) }
t = Tree.new(array)
puts "object successfully made" if t != nil 
puts "this is a balanced tree" if t.balanced?(t.root) == true 
puts "level order:"
t.recursive_level_order
puts "pre_order:"
t.pre_order(t.root)
puts "in order:"
t.in_order(t.root)
puts "post order:"
t.post_order(t.root)

t.insert(200,t.root)
t.insert(300,t.root)
t.insert(400,t.root)
t.delete(400,t.root)
t.insert(500,t.root)  #unbalance the tree 
puts "is it balanced?"
puts "no not balanceed" if t.balanced?(t.root) == false 
t.rebalance!
puts "yes it's re-balanced!!!!" if t.balanced?(t.root) == true 
