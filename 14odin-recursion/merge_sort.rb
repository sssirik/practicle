# frozen_string_literal: true

def merge_sort(array)
    return array if array.length <= 1
    
    mid = array.length / 2
    left_half = array[0...mid]
    right_half = array[mid..-1]
    
    left_sorted = merge_sort(left_half)
    right_sorted = merge_sort(right_half)
    
    merge(left_sorted, right_sorted)
  end
  
  def merge(left, right)
    result = []
    left_index = 0
    right_index = 0
    
    while left_index < left.length && right_index < right.length
      if left[left_index] <= right[right_index]
        result << left[left_index]
        left_index += 1
      else
        result << right[right_index]
        right_index += 1
      end
    end
    
    result += left[left_index..-1] if left_index < left.length
    result += right[right_index..-1] if right_index < right.length
    
    result
  end