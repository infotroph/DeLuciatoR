library(ggplot2)
library(devtools) # for file downloads from Github
library(grid)
library(gridExtra) # for multiplot demo
library(gtable)

source("ggthemes.r")
source_url("https://raw.githubusercontent.com/infotroph/ggplot-ticks/master/mirror.ticks.r")


# An example scatterplot from the ggplot2 `mtcars` dataset:
# Plot weight converted to kg against miles per US gallon
# First something you might use in a small on-screen display...
carplot = (ggplot(mtcars, aes(wt*453.592, mpg))
	+geom_smooth(method="lm", se=TRUE, linetype="dotted", color="black")
	+geom_point()
	+xlab("Vehicle weight (kg)")
	+ylab("MPG")
	+theme_ggEHD(12))

# ...then one with room to blow it up.
carbigplot = (ggplot(mtcars, aes(wt*453.592, mpg))
	+geom_smooth(method="lm", se=TRUE, linetype="dotted", color="black")
	+geom_point(size=4)
	+xlab("Vehicle weight (kg)")
	+ylab("MPG")
	+theme_ggEHD(32))

# Let's put both plots side-by-side to see the differences.
# Try resizing the plot window and watch what happens.
# The settings you want depend on your image size!
# Note that mirror.ticks converts the plot from a ggplot object
# to a gtable object, so it should be the last thing you call after
# you've finished modifying the rest of the plot.
grid.arrange(
	mirror.ticks(carplot),
	mirror.ticks(carbigplot),
	nrow=1)
