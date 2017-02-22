

library(dplyr)

#example from R document by typing ?interp
interp(~ x + y, x = 10)
interp(lazy(x + y), x = 10)
interp(quote(x + y), x = 10)
interp("x + y", x = 10)
class(interp("x + y", x = 10))

#now do some test, all statments passed
mtcars2<- mtcars
#option 1 using a formular
f1 <- interp(~mean(var), var = as.name("disp"))
f2 <- interp(~mean(var), var = as.name("mpg"))
dots <- list(f1, f2)
summarise_(mtcars, .dots = setNames(dots, c(paste0("disp", "_mean"), paste0("mpg","_mean"))))

#option 2 using quote()
f3 <- interp( quote(var1 + 1000) , var1 = as.name("disp"))
f4 <- interp( quote(var2 + 2000), var2 = as.name("mpg"))
mutate_(mtcars2, .dots=setNames(list(f3, f4), c(paste0("disp", "_v2"), paste0("mpg","_v2")) ) )

#option 3 using a string
f5 <- interp("var - 1000", var = as.name("disp"))
mutate_(mtcars2, .dots = setNames(f5,"disp_v3"))

#now make a function to enable dynamic summary--

user_summary <- function(in_data, var1, var2, summary_fun = "mean"){
  
  if(summary_fun == "mean"){
    
    f1 <- interp(~mean(var, na.rm = TRUE), var = as.name(var1))
    
    f2 <- interp(~mean(var, na.rm = TRUE), var = as.name(var2))
    
  }else if(summary_fun == "sum"){
    
    
    f1 <- interp(~sum(var, na.rm = TRUE), var = as.name(var1))
    
    f2 <- interp(~sum(var, na.rm = TRUE), var = as.name(var2))    
    
  }
  
  dots <- list(f1, f2)
  
  if(summary_fun == "mean"){
    
    outcome <- summarise_(in_data,  .dots = setNames(dots, c(paste0(var1, "_mean"), paste0(var2, "_mean"))) )
  
  }else if(summary_fun == "sum"){
    
    outcome <- summarise_(in_data,  .dots = setNames(dots, c(paste0(var1, "_sum"), paste0(var2, "_sum"))) )
    
    
  }
  
  print(outcome)
  
  return(outcome)
  
}

out1 <- user_summary(mtcars, "mpg", "disp")
#QC
apply(mtcars, 2, mean)
out2 <- user_summary(mtcars, "mpg", "disp", summary_fun = "sum")
#QC
apply(mtcars, 2, sum)
