# Script to fit the negative exponential function for DAD data
# Created October 11, 2023 by John Drake and Anna Willoughby to illustrate constrained fitting of a nonlinear function

DAD <- function(c,x,f) c^(x-d)+f

x <- seq(1:15)
c <- 0.8
d <- 0.2
f <- 1

y <- DAD(c,x,f)
y.noise <- y+rnorm(15, sd=0.1)

plot(x,y, log='', pch=15, ylim=c(0,4))
points(x,y.noise, col='red', pch=20)

obs <- data.frame(y=y.noise, x=x)

fits <- nls(y ~ c^(x-d)+f, 
            data = obs,
            start = list(c = 0.78, d=0.1, f=0.9)
)

## using the minpack.lm package 
library(minpack.lm)
# load data 
read.csv(file = )
