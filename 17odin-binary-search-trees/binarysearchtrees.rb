# frozen_string_literal: true

class Node
    include Comparable
    attr_accessor :data, :left, :right
  
    def initialize(data)
      @data = data
      @left = nil
      @right = nil
    end
  
    def <=>(other)
      data <=> other.data
    end
  end
  
  class Tree
    attr_reader :root
  
    def initialize(array)
      @root = build_tree(array.uniq.sort)
    end
  
    def build_tree(array)
      return nil if array.empty?
      mid = array.length / 2
      node = Node.new(array[mid])
      node.left = build_tree(array[0...mid])
      node.right = build_tree(array[mid + 1..-1])
      node
    end
  
    def insert(value, node = @root)
      return Node.new(value) if node.nil?
      return node if value == node.data
  
      if value < node.data
        node.left = insert(value, node.left)
      else
        node.right = insert(value, node.right)
      end
      node
    end
  
    def delete(value, node = @root)
      return nil if node.nil?
  
      if value < node.data
        node.left = delete(value, node.left)
      elsif value > node.data
        node.right = delete(value, node.right)
      else
        return node.right if node.left.nil?
        return node.left if node.right.nil?
  
        temp = min_value_node(node.right)
        node.data = temp.data
        node.right = delete(temp.data, node.right)
      end
      node
    end
  
    def find(value, node = @root)
      return nil if node.nil?
      return node if value == node.data
      value < node.data ? find(value, node.left) : find(value, node.right)
    end
  
    def level_order(&block)
      return [] if @root.nil?
      queue = [@root]
      result = []
      until queue.empty?
        node = queue.shift
        block_given? ? yield(node) : result << node.data
        queue << node.left unless node.left.nil?
        queue << node.right unless node.right.nil?
      end
      result unless block_given?
    end
  
    def inorder(node = @root, &block)
      return [] if node.nil?
      result = []
      result += inorder(node.left, &block)
      block_given? ? yield(node) : result << node.data
      result += inorder(node.right, &block)
      result
    end
  
    def preorder(node = @root, &block)
      return [] if node.nil?
      result = []
      block_given? ? yield(node) : result << node.data
      result += preorder(node.left, &block)
      result += preorder(node.right, &block)
      result
    end
  
    def postorder(node = @root, &block)
      return [] if node.nil?
      result = []
      result += postorder(node.left, &block)
      result += postorder(node.right, &block)
      block_given? ? yield(node) : result << node.data
      result
    end
  
    def height(node = @root)
      return -1 if node.nil?
      [height(node.left), height(node.right)].max + 1
    end
  
    def depth(value, node = @root, depth = 0)
      return nil if node.nil?
      return depth if value == node.data
      value < node.data ? depth(value, node.left, depth + 1) : depth(value, node.right, depth + 1)
    end
  
    def balanced?(node = @root)
      return true if node.nil?
      left_height = height(node.left)
      right_height = height(node.right)
      (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    end
  
    def rebalance
      @root = build_tree(inorder)
    end
  
    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  
    private
  
    def min_value_node(node)
      current = node
      current = current.left until current.left.nil?
      current
    end
  end
  
  # Драйвер-скрипт
  array = Array.new(15) { rand(1..100) }
  tree = Tree.new(array)
  
  puts "Сбалансировано?: #{tree.balanced?}"
  puts "Level order: #{tree.level_order}"
  puts "Preorder: #{tree.preorder}"
  puts "Postorder: #{tree.postorder}"
  
  5.times { tree.insert(rand(101..200)) }
  puts "После вставки больших чисел - Сбалансировано?: #{tree.balanced?}"
  
  tree.rebalance
  puts "После перебалансировки - Сбалансировано?: #{tree.balanced?}"
  
  puts "Level order: #{tree.level_order}"
  puts "Preorder: #{tree.preorder}"
  puts "Postorder: #{tree.postorder}"
  
  puts "\nВизуализация дерева:"
  tree.pretty_print