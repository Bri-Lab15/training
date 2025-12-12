# custom_enumerables.rb

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < self.size
      yield(self.to_a[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < self.size
      yield(self.to_a[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    selected = []
    my_each { |el| selected << el if yield(el) }
    selected
  end

  def my_all?
    if block_given?
      my_each { |el| return false unless yield(el) }
    else
      my_each { |el| return false unless el }
    end
    true
  end

  def my_any?
    if block_given?
      my_each { |el| return true if yield(el) }
    else
      my_each { |el| return true if el }
    end
    false
  end

  def my_none?
    if block_given?
      my_each { |el| return false if yield(el) }
    else
      my_each { |el| return false if el }
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) }
    elsif !item.nil?
      my_each { |el| count += 1 if el == item }
    else
      count = size
    end
    count
  end

  def my_map(proc_obj = nil)
    return to_enum(:my_map) unless block_given? || proc_obj

    mapped = []
    if proc_obj && block_given?
      my_each { |el| mapped << proc_obj.call(yield(el)) }
    elsif proc_obj
      my_each { |el| mapped << proc_obj.call(el) }
    else
      my_each { |el| mapped << yield(el) }
    end
    mapped
  end

  def my_inject(initial = nil, sym = nil)
    arr = to_a
    if initial.nil? && sym.nil?
      memo = arr.first
      i = 1
    elsif sym.nil?
      memo = initial
      i = 0
    else
      memo = initial
      i = 0
    end

    if sym.is_a?(Symbol)
      while i < arr.length
        memo = memo.send(sym, arr[i])
        i += 1
      end
    else
      while i < arr.length
        memo = yield(memo, arr[i])
        i += 1
      end
    end
    memo
  end
end

class Array
  def multiply_els
    my_inject(1) { |product, n| product * n }
  end
end
