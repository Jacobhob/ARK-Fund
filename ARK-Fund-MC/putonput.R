library(mnormt)

binormsdist <- function(x1, x2, rho) {
  pmnorm(c(x1, x2), varcov = matrix(c(1, rho, rho, 1), nrow=2))
}

.d1 <- function(s, k, v, r, tt, d)
  (log(s/k) + (r-d+v^2/2)*tt)/(v*sqrt(tt))

.d2 <- function(s, k, v, r, tt, d)
  .d1(s, k, v, r, tt, d) - v*tt^(0.5)

.nd1 <- function(s, k, v, r, tt, d)
  pnorm(.d1(s, k, v, r, tt, d))

.nd2 <- function(s, k, v, r, tt, d)
  pnorm(.d2(s, k, v, r, tt, d))

putonput.S0 <- function(s, kuo, kco, v, r, t1, t2, d) {
  a1 <- .d1(s, s, v, r, t1, d)
  a2 <- a1 - v * t1 ^ 0.5
  d1 <- .d1(s, kuo, v, r, t2, d)
  d2 <- d1 - v * t2 ^ 0.5
  temp <- (s * exp(-d * t2) * binormsdist(a1, -d1, -(t1 / t2) ^ 0.5)
           - kuo * exp(-r * t2) * binormsdist(a2, -d2, -(t1 / t2) ^ 0.5)
           + kco * exp(-r * t1) * pnorm(a2))
  return(c(price=temp))
}


#putonput.S0(307.08, 0.85*307.08, 4.577266, 0.2407, 0.008, 0.5, 1, 0.018)