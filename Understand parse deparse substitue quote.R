df <- data.frame(x = 1:5)
transform(df, x2 = x * x, x3 = x2 * x)
plyr::mutate(df, x2 = x * x, x3 = x2 * x)
transform(df, x2 = x * x)

# a good example for using parse()
cat("x <- c(1, 4)\n  print(x ^ 3 -10) ; outer(1:7, 5:9)\n", file = "D:/R Memo/xyz.Rdmped")
parse(file = "D:/R Memo/xyz.Rdmped", n=3)
parse(file = "D:/R Memo/xyz.Rdmped", n=2)
parse(file = "D:/R Memo/xyz.Rdmped", n=1)
eval(parse(file = "D:/R Memo/xyz.Rdmped", n=1))
eval(parse(file = "D:/R Memo/xyz.Rdmped", n=3))



e1 <- new.env()
e1$x <- 33
x<- 99
substitute(x - 5, e1)
substitute(x-5)
is.expression(substitute(x-5)) #not an expression
typeof(substitute(x-5))  #language
is.expression(quote(x-5)) #not an expression

deparse(substitute(x - 5, e1))
deparse(substitute(x-5))
is.character(deparse(substitute(x-5)))
eval(substitute(x - 5, e1))


# a good way to use substitue and deparse
library(dplyr)
mutate_(df, "x2=x^2")
mutate_(df, ~x^2)
is.expression(~x^2)

s1 <- deparse(substitute(x^2))
mutate_(df, s1)


require(stats); require(graphics)
deparse(args(lm))

myplot <-
  function(x, y) {
    plot(x, y, xlab = deparse(substitute(x)),
         ylab = deparse(substitute(y)))
  }

a <- c(1,2,3,4,5)
b <- c(7,8,9,10,11)
myplot(a,b)


e <- quote(`foo bar`)
deparse(e)
deparse(e, backtick = TRUE)
