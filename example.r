library(ggplot2)
library(devtools) # for file downloads from Github
library(grid)
library(gtable)

source("ggthemes.r")
source_url("https://raw.githubusercontent.com/infotroph/ggplot-ticks/master/mirror.ticks.r")

carplot = (ggplot(mtcars, aes(wt, mpg))
	+geom_point()
	+geom_smooth(se=FALSE)
	+theme_ggEHD())

# Note that mirror.ticks converts the plot from a ggplot object 
# to a gtable object. Don't call it until you've finished modifying 
# the rest of the plot.

plot(mirror.ticks(carplot))