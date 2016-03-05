library(ggplot2)
library(DeLuciatoR)
library(gridExtra) # for multiplot demo
library(ggplotTicks)

# An example scatterplot from the R built-in `mtcars` dataset:
# Plot weight converted to kg against miles per US gallon
carplot = (ggplot(mtcars, aes(wt*453.592, mpg))
	+geom_smooth(method="lm", se=TRUE, linetype="dotted", color="black")
	+geom_point()
	+xlab("Vehicle weight (kg)")
	+ylab("MPG"))

# Add axis ticks to the top and right sides
carplot = mirror_ticks(carplot)

# Now let's see some themes.
# First something you might use in a small on-screen display...	
car_small = carplot + theme_ggEHD(12)

# ...then one with room to blow it up.
# Note that themes do not affect point size, so I set those manually.
car_big = carplot + geom_point(size=4) + theme_ggEHD(32)

# Let's put both plots side-by-side to see the differences.
# Try resizing the plot window and watch what happens.
# The settings you want depend on your image size!
grid.arrange(car_small, car_big, nrow=1)


# README examples
p = (ggplot(iris, aes(Sepal.Length, Petal.Width, shape=Species))
	+ geom_point(size=2)
	+ geom_smooth(method="lm")
	+theme_ggEHD())

plot(p) # "...hmm, that text is too small..."
plot(p + theme_ggEHD(base_size=24)) # "...better, but the legend needs to move..."
p = p + theme_ggEHD(base_size=24) + theme(legend.position=c(0.85, 0.25)) # "...Aaah, good."

ggsave_fitmax(
	filename="iris_plot.pdf",
	plot=p,
	maxwidth=6.5,
	maxheight=9)

