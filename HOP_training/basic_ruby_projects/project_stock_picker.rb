def stock_picker(prices)
  # Best pair of days to return — default to [0, 1]
  best_days = [ 0, 1 ]

  # Track the lowest price and its index (best buy so far)
  lowest_price = prices[0]
  lowest_day = 0

  # Track the best profit found so far
  max_profit = prices[1] - prices[0]

  # Start iterating from day 1 (you can't sell on day 0)
  prices.each_with_index do |price, day|
    next if day == 0  # Skip day 0 because you can't sell yet

    # If the current price is lower than what we've seen,
    # update the lowest buying price and day
    if price < lowest_price
      lowest_price = price
      lowest_day = day
    end

    # Calculate potential profit if we sell today
    profit = price - lowest_price

    # If this is the best profit seen so far, update our answer
    if profit > max_profit
      max_profit = profit
      best_days = [ lowest_day, day ]
    end
  end

  best_days
end

# Example test from the assignment:
p stock_picker([ 17, 3, 6, 9, 15, 8, 6, 1, 10 ])
# => [1, 4]  (Buy at $3 on day 1, sell at $15 on day 4)
