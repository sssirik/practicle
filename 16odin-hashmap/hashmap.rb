# frozen_string_literal: true

class HashMap
  LOAD_FACTOR = 0.75

  def initialize
    @capacity = 16
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.to_s.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code % @capacity
  end

  def set(key, value)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    existing_index = bucket.index { |entry| entry[0] == key }
    
    if existing_index
      bucket[existing_index][1] = value
    else
      bucket << [key, value]
      @size += 1
      resize if load_factor > LOAD_FACTOR
    end
  end

  def get(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    entry = @buckets[index].find { |k, _| k == key }
    entry ? entry[1] : nil
  end

  def has?(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index].any? { |k, _| k == key }
  end

  def remove(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    entry_index = bucket.index { |k, _| k == key }
    return nil unless entry_index

    removed = bucket.delete_at(entry_index)
    @size -= 1
    removed[1]
  end

  def length
    @size
  end

  def clear
    @capacity = 16
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map(&:first) }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map(&:last) }
  end

  def entries
    @buckets.flat_map(&:dup)
  end

  private

  def load_factor
    @size.to_f / @capacity
  end

  def resize
    old_entries = entries
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    @size = 0
    old_entries.each { |key, value| set(key, value) }
  end
end

# Тестирование
map = HashMap.new
map.set('apple', 'red')
map.set('banana', 'yellow')
map.set('carrot', 'orange')
map.set('dog', 'brown')
map.set('elephant', 'gray')
map.set('frog', 'green')
map.set('grape', 'purple')
map.set('hat', 'black')
map.set('ice cream', 'white')
map.set('jacket', 'blue')
map.set('kite', 'pink')
map.set('lion', 'golden')

puts "Size: #{map.length}"
puts "Has apple: #{map.has?('apple')}"
puts "Get banana: #{map.get('banana')}"
puts "Keys: #{map.keys}"
puts "Values: #{map.values}"

map.set('moon', 'silver')
puts "After resize - Size: #{map.length}"
puts "Get moon: #{map.get('moon')}"

map.remove('apple')
puts "After remove - Size: #{map.length}"
puts "Has apple: #{map.has?('apple')}"

map.clear
puts "After clear - Size: #{map.length}"