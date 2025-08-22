# frozen_string_literal: true

module Enumerable
  # my_each
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  # my_each_with_index
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
    self
  end

  # my_select
  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |item| result << item if yield(item) }
    result
  end

  # my_all?
  def my_all?(pattern = nil)
    if pattern
      my_each { |item| return false unless pattern === item }
    elsif block_given?
      my_each { |item| return false unless yield(item) }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  # my_any?
  def my_any?(pattern = nil)
    if pattern
      my_each { |item| return true if pattern === item }
    elsif block_given?
      my_each { |item| return true if yield(item) }
    else
      my_each { |item| return true if item }
    end
    false
  end

  # my_none?
  def my_none?(pattern = nil, &block)
    !my_any?(pattern, &block)
  end

  # my_count
  def my_count(item = nil)
    count = 0

    if item
      my_each { |elem| count += 1 if elem == item }
    elsif block_given?
      my_each { |elem| count += 1 if yield(elem) }
    else
      count = size
    end

    count
  end

  # my_map
  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc

    result = []
    if proc
      my_each { |item| result << proc.call(item) }
    else
      my_each { |item| result << yield(item) }
    end
    result
  end

  # my_inject
  def my_inject(initial = nil, sym = nil)
    raise ArgumentError, 'wrong number of arguments' unless (!initial && !sym) || (sym && !block_given?)

    accumulator = initial.nil? ? first : initial
    start_index = initial.nil? ? 1 : 0

    if sym
      my_each_with_index do |item, index|
        next if index < start_index

        accumulator = accumulator.send(sym, item)
      end
    else
      my_each_with_index do |item, index|
        next if index < start_index

        accumulator = yield(accumulator, item)
      end
    end

    accumulator
  end
end
