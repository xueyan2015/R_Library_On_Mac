


library(dplyr)
library(pryr)
library(lattice)
library(pryr)
#this example works
xyplot(mpg ~ disp, data = mtcars)
x <- quote(mpg)
y <- quote(disp)
xyplot(x ~ y, data = mtcars)

subs(xyplot(x ~ y, data = mtcars))

xyplot2 <- function(x, y, data = data) {
  eval(substitute(xyplot(x ~ y, data = data)))
}
xyplot2(mpg, disp, data = mtcars)




set.seed(1234)
df<-data.frame(a=c('A','B','C','A','A','B'),b=rnorm(6))
#1
col0 <-'b'
subset(df, eval(as.name(col0)) >0 )
#it seems it never works with mutate()
mutate(df, s = eval(quote(as.name(col0) * 2)))
#this alternative approach works
eval(substitute(b * 2) , envir=df)

#this one does not work... because substitute does not replace variable with its value in global env.
col <- as.name('b')
substitute(subset(df, col >0 ))
eval(substitute(subset(df, col >0 )))
#this one work
subs(subset(df, col >0 ))
eval(subs(subset(df, col >0 )))

#now try a function
f1 <- function(){
  
  # substitute(subset(df, col >0 ))
  subs(subset(df, col >0 ))
  
}

f1()
#this one does not work.
eval(subs(subset(df, quote(b) >0 )))
#this one does not work either
eval(subset(df, quote(b) >0 ))
#this one really works!!!
xx <- quote(b)
eval(subs(subset(df, xx >0 )))

eval()

#now this one works...
f2 <- function(condition){
  
  eval(substitute(subset(df, condition )))
  
}
f2(b>0)

f2b <- function(condition_str){
  
  eval(substitute(subset(df, parse(text=condition_str ))))
  
}
f2b("b>0")



f3 <- function(col_name){

  
}


####


# a + b + c -> a * b * c
# f(g(a, b), c) -> (a + b) * c
# f(a < b, c, d) -> if (a < b) c else d

substitute(a + b +c, list('+'=quote(`*`)))

substitute(a + b +c, list('+'=`*`))




