
#install.packages(c("rgl", "car"))

library("rgl")
library("car")
data(iris)
head(iris)

sep.l <- iris$Sepal.Length
sep.w <- iris$Sepal.Width
pet.l <- iris$Petal.Length

scatter3d(x = sep.l, y = pet.l, z = sep.w)
scatter3d(x = sep.l, y = pet.l, z = sep.w,
          point.col = "blue", surface=FALSE)


scatter3d(x = sep.l, y = pet.l, z = sep.w, groups = iris$Species)
scatter3d(x = sep.l, y = pet.l, z = sep.w, groups = iris$Species, grid = FALSE)



### Start...
Annual.Sales <- iris$Sepal.Length * 1000000
Business.Area <- iris$Sepal.Width * 40
Strip.Sales<- iris$Petal.Length * 20000

city.label <- factor(ifelse(as.character(iris$Species) == "virginica", "City Tier 1", ifelse(as.character(iris$Species) == "versicolor", "City Tier 2", "City Tier 3")))


scatter3d(x = Annual.Sales, y = Strip.Sales, z = Business.Area, groups = city.label, grid = FALSE)

#reference--
#  http://www.sthda.com/english/wiki/amazing-interactive-3d-scatter-plots-r-software-and-data-visualization
