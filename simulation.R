simulation <- function(days, r, d, coupon, sigma, initial.price, management.fee, c) {
  # Stock price simulation


  for (i in 1:(days-1)) {
    dW <- sqrt(1/252) * rnorm(1)
    price[i+1,1] <- price[i,1] * exp((r - d - (1/2) * sigma^2) * (1/252) + sigma * dW)
  }
  
  k1 <<- c * price[1,1]   # Strike price of first put
  k2 <<- c * price[126,1] # Strike price of second put
  k3 <<- c * price[252,1] # Strik3 price of third put
  k4 <<- c * price[378,1] # Strike price of final put
  p  <<- euro.put(price[1,1], sigma, r, d, 0.5, c*initial.price) # Strike price of put on put
  
  cash[1,1] <- initial.price - p - 
               put.on.put.formula(price[1,1], k1, p, sigma, r, 0.5, 1, d, initial.price) - 
               put.on.put.formula(price[1,1], k1, p, sigma, r, 1, 1.5, d, initial.price) - 
               put.on.put.formula(price[1,1], k1, p, sigma, r, 1.5, 2, d, initial.price)
  
  # Portfolio value is updated for each trading day
  for (j in 2:505) {
    # Day 2 ~ 126, period 0, the first half year:
    if (j <= 125) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 0.5-j/252, k1) +
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 0.5-j/252, 1-j/252, d, initial.price) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1-j/252, 1.5-j/252, d, initial.price) +
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1.5-j/252, 2-j/252, d, initial.price)
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252))
      total.value[j,1] <- value[j,1] + cash[j,1]
    } 
    # Day 126: execute put on put, roll put forward, and deliver the first dividend
    else if (j == 126) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 1-j/252, k2) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1-j/252, 1.5-j/252, d, initial.price) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1.5-j/252, 2-j/252, d, initial.price)
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252)) - p + max(k1 - price[127,1], 0) - 
        initial.price * coupon
      total.value[j,1]  <- value[j,1] + cash[j,1] + initial.price * coupon
      bank.revenue[1,1] <- max(euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                               euro.put(price[j,1], sigma, r, d, 0.5, c*price[1,1]),0) + 
                           euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                           euro.put(price[j,1], sigma, r, d, 0.5, c*price[j,1])
    }
    # Day 128 ~ 251, period 1, the second half year:
    else if (j <= 251) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 1-j/252, k2) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1-j/252, 1.5-j/252, d, initial.price) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1.5-j/252, 2-j/252, d, initial.price)
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252))
      total.value[j,1] <- value[j,1] + cash[j,1] + initial.price * coupon
    }
    # Day 252: execute put on put, roll put forward, and deliver the second dividend
    else if (j == 252) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 1.5-j/252, k3) +
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1.5-j/252, 2-j/252, d, initial.price)
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252)) - p + max(k2 -price[253,1], 0) - 
        initial.price * coupon
      total.value[j,1]  <- value[j,1] + cash[j,1] + initial.price * coupon * 2
      bank.revenue[2,1] <- max(euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                               euro.put(price[j,1], sigma, r, d, 0.5, c*price[1,1]),0) + 
                           euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                           euro.put(price[j,1], sigma, r, d, 0.5, c*price[j,1])
    }
    # Day 253 ~ 377, period 3, the third half year:
    else if (j <= 377) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 1.5-j/252, k3) + 
                    put.on.put.formula(price[j,1], k1, p, sigma, r, 1.5-j/252, 2-j/252, d, initial.price)
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252)) 
      total.value[j,1] <- value[j,1] + cash[j,1] + initial.price * coupon * 2
    }
    # Day 378: execute put on put, roll put forward,deliver the last dividend
    else if (j == 378) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 2-j/252, k4) 
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252)) - p + max(k3 -price[379,1], 0) - 
                    initial.price * coupon
      total.value[j,1]  <- value[j,1] + cash[j,1] + initial.price * coupon * 3
      bank.revenue[3,1] <- max(euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                               euro.put(price[j,1], sigma, r, d, 0.5, c*price[1,1]),0) + 
                           euro.put(price[1,1], sigma, r, d, 0.5, c*price[1,1]) - 
                           euro.put(price[j,1], sigma, r, d, 0.5, c*price[j,1])
    }
    # Day 379 ~ 504, period 4, the last half year:
    else if (j <= 504) {
      value[j,1] <- euro.put(price[j,1], sigma, r, d, 2-j/252, k4)  
      cash[j,1]  <- cash[j-1,1] * exp(r*(1/252)) 
      total.value[j,1] <- value[j,1] + cash[j,1] + initial.price * coupon * 3
    }
    # Day 505, the last day: execute the last put
    else if (j == 505) {
      value[j,1] <- 0
      cash[j,1]  <- cash[j-1,1] * exp(r * (1 / 252)) + max(k4 - price[505,1], 0) 
      total.value[j,1] <- cash[j,1] + initial.price * coupon * 3
    }
    
    # If the value of our portfolio is below bond floor,
    # we clear out all position and invest in bond to make pricipal guaranteed.
    if (!exists("period", mode = "function")) {
      period <- function(j) {
        if (j <= 126) {period <- 0} 
        else if (j <= 252) {period <- 1} 
        else if (j <= 378) {period <- 2} 
        else if (j <= 505) {period <- 3}
      }
    }
    if (total.value[j,1] < ((0.85 * exp(-r * (2-j/252)) + 
                            coupon * exp(-r * max(1.5-j/252, 0)) + 
                            coupon * exp(-r * max(1-j/252, 0)) + 
                            coupon * exp(-r * max(0.5-j/252, 0))) * 
                            initial.price)
                            || (price[j, 1] > 2*initial.price)) {
      cash[j,1] <- cash[j,1] + value[j,1]
      value[j:505,1] <- 0
      for (n in (j+1):505) {
        cash[n,1] <- cash[n-1,1] * exp(r * 1 / 252)
        total.value[n,1] <- cash[n,1] + period(j) * coupon * initial.price
      }
      bank.revenue[(period(j)+1):4,1] <- 0
      print(paste("Knock out in day:",j))
      knockout.date <- j
    }
    
    if (knockout.date != 0) {
      break
    }
  }
  
  print(paste("Simulation[",a, "] successful!"))
  
  # Store simulation results in data frames
  RETURN      <<- c(RETURN, (total.value[505,1]/initial.price - 1))
  KNOCKOUT    <<- c(KNOCKOUT, knockout.date)
  PRICE       <<- cbind(PRICE, price)
  CASH        <<- cbind(CASH, cash)
  VALUE       <<- cbind(VALUE, value)
  TOTAL.VALUE <<- cbind(TOTAL.VALUE, total.value)
  BANK        <<- cbind(BANK, bank.revenue)
}
