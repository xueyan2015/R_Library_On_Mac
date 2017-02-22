

# install.packages("plyr")
# install.packages("dplyr")
# install.packages("pryr")
library(plyr)
library(dplyr)

quote(a + b)[[4]]
str(quote(a+b))
library(pryr)

make_call(quote(mean), list(quote(x), na.rm = TRUE))

m1 <- quote(read.delim("data.txt", sep = "|"))
m1b<- standardise_call(m1)
str(m1)
str(m1b)

as.list(m1)

as.list(m1b)
m1b[[2]]
m1b[["file"]]
fname<- "data2"
m1b[[2]] <- quote(paste0(fname,".txt"))

m1b[[2]]

setwd("/Users/xueyan/R_Work")
df1 <- data.frame(x = c(1,2,3), y=c(4,5,6))
write.csv(df1,"first_file_from_R.csv", row.names = FALSE)


a <- call("mean", 1:10)
eval(a)
f_name <- "sum"
b <- call(f_name, 1:10)
eval(b)

?standardise_call
(a <- call("mean", 1:10))
eval(a)
?summarize()

df <- data.frame(id = c('A','B','B','A', 'B'), x = c(1,2,3,4,5))
df_grp <- group_by(df, id)
summarize(df_grp, x_sum = sum(x), x_mean = mean(x))

group_by(df, id) %>% summarize(x_sum = sum(x))

#now make a call -- 
# call_1 <- call("summarize", quote(x_sum = sum(x)))
# call_2 <- call("summarize", quote(x_sum =sum(x)), quote(x_mean = mean(x)))

call_3 <- call("summarize", quote(df_grp),quote(sum(x)))
is.expression(call_3)  
is.call(call_3)
eval(call_3)
standardise_call(call_3)

call_4 <- make_call("summarize", list(df_grp, quote(sum(x))))
eval(call_4)

call_5 <- make_call(quote(summarize), list(df_grp, quote(sum(x))))
eval(call_5)

#call_6终于实现了我的目标！
call_6 <- make_call(quote(summarize), list(df_grp, x_sum = quote(sum(x)), x_mean=quote(mean(x))))
eval(call_6)  
standardise_call(call_6)

dynamic_summary <- function(q1=NULL, q2=NULL){
  statement_lst <- NULL
  if(is.null(q1) & is.null(q2)){
    
    stop("Please specify at least one non-NULL argument in this function!")
    
  } else if(is.null(q1) & !is.null(q2)){
    statement_lst <- list(df_grp, x_mean = quote(mean(x)))
  } else if(!is.null(q1) & is.null(q2)){
    statement_lst <- list(df_grp, x_sum= quote(sum(x)))
  } else if (!is.null(q1) & !is.null(q2)){
    statement_lst <- list(df_grp, x_sum= quote(sum(x)), x_mean = quote(mean(x)))
  }
    
  call0 <- make_call(quote(summarise), statement_lst)
  outcome <- eval(call0)
  return(outcome)
  
}

dynamic_summary(q1=1, q2=1)
dynamic_summary(q2=1)
dynamic_summary(q1=1)
dynamic_summary()
out1 <- dynamic_summary(q1=1, q2=1)
as.data.frame(out1)
#another try that also works
dynamic_summary2 <- function(summary_statement){
  
  if(!is.null(summary_statement)){
    
    call0 <- make_call(quote(summarise), list(df_grp, new_col = summary_statement))
    eval(call0)
  } else{stop("Plase specify the function argument!")}
} 
dynamic_summary2(quote(mean(x)))

#this one does not work - Error in mean(x) : 找不到对象'x'
dynamic_summary3 <- function(summary_statement){
  
  if(!is.null(summary_statement)){
    
    call0 <- make_call(quote(summarise), list(df_grp, new_col = quote(summary_statement)))
    eval(call0)
  } else{stop("Plase specify the function argument!")}
} 

dynamic_summary3(mean(x))

dynamic_summary3 <- function(summary_statement, env = parent.frame()){
  env2 <- new.env(parent = env)
  
  if(!is.null(summary_statement)){
    
    call0 <- make_call(quote(summarise), list(df_grp, new_col = eval(substitute(summary_statement, env2))))
    eval(call0)
  } else{stop("Plase specify the function argument!")}
} 
dynamic_summary3(mean(x))


call_6 <- make_call(quote(mutate), list(df, new_col = quote(x^2)))
eval(call_6)
call_7 <- make_call(quote(mutate), list(df, "new_col" = quote(x^2)))
call_7
eval(call_7)
identical(call_6,call_7)

#this one does not work.
colname_user_defined <- quote("new_col")
call_8 <- make_call(quote(mutate), list(df, colname_user_defined = quote(x^2)))
call_8
eval(call_8)
