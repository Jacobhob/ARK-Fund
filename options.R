# Pricing functions for component options

library(mnormt)

# The function to calculate the price of a european put.
euro.put <- function(s0, sigma, r, d, T, K) { 
  d1 <- (log(s0 / K) + (r - d + (0.5) * sigma^2) * T) / (sigma * sqrt(T))
  d2 <- d1 - sigma * sqrt(T)
  K * exp(-r * T) * pnorm(-d2) - s0 * exp(-d * T) * pnorm(-d1)
}

# The function to calculate the price of a european call.
euro.call <- function(s0, sigma, r, d, T, K) {
  d1 <- (log(s0 / K) + (r - d + (0.5) * sigma^2) * T) / (sigma * sqrt(T))
  d2 <- d1 - sigma * sqrt(T)
  pnorm(d1) * s0 * exp(-d * T) - pnorm(d2) * K * exp(-r * (T))
}

# Use Monte Carlo simulation to price a put on put. 
# This put-on-put is an upward protection.
put.on.put.MC <- function(s0, sigma, r, d, T, t, p, K, trials = 10000) {
  # T: maturity of put on put
  # t: maturity of underlying put
  # p: strike price of put on put
  dW <- rnorm(trials) * sqrt(T)
  sT <- s0 * exp((r - d - (1/2) * sigma^2) * T + sigma * dW)
  put.price <- euro.put(sT, sigma, r, d, t, K)
  payoff <- pmax(p - put.price,0)
  exp(-r * T) * mean(payoff)
}

# Use explicit formula to price a put on put
binormsdist <- function(x1, x2, rho) {
  pmnorm(c(x1, x2), varcov = matrix(c(1, rho, rho, 1), nrow=2))
}

.d1 <- function(s, k, v, r, tt, d) {
  .d1 <- (log(s/k) + (r-d+v^2/2)*tt)/(v*sqrt(tt))
}

.d2 <- function(s, k, v, r, tt, d) {
  .d1(s, k, v, r, tt, d) - v*tt^(0.5)
}

#' @param s Price of the asset on which the underlying option is
#'     written
#' @param v Volatility of the underlying asset, defined as the
#'     annualized standard deviation of the continuously-compounded
#'     return
#' @param r Annual continuously-compounded risk-free interest rate
#' @param d Dividend yield of the underlying asset, annualized,
#'     continuously-compounded
#' @param kuo strike on the underlying option
#' @param kco strike on compound option (the price at which you would
#'     buy or sell the underlying option at time t1)
#' @param t1 time until exercise for the compound option
#' @param t2 time until exercise for the underlying option
put.on.put.formula <- function(s, kuo, kco, v, r, t1, t2, d) {
  a1 <- .d1(s, s, v, r, t1, d)
  a2 <- a1 - v * t1 ^ 0.5
  d1 <- .d1(s, kuo, v, r, t2, d)
  d2 <- d1 - v * t2 ^ 0.5
  temp <- (s * exp(-d * t2) * binormsdist(a1, -d1, -(t1 / t2) ^ 0.5)
           - kuo * exp(-r * t2) * binormsdist(a2, -d2, -(t1 / t2) ^ 0.5)
           + kco * exp(-r * t1) * pnorm(a2))
  return(max(c(price=temp),0))
}
