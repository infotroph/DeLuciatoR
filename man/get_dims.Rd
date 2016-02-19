\name{get_dims}
\alias{get_dims}
\title{
	Find overall dimensions of a ggplot
}
\description{
	Computes the largest possible dimensions for a fixed-aspect ggplot that still fits inside the given maximum height and width.
}
\usage{
	get_dims(ggobj, maxheight, maxwidth=maxheight, units="in", ...)
}
\arguments{
	\item{ggobj}{
		A ggplot or gtable object.
	}
	\item{maxheight, maxwidth}{
		Numeric, giving argest allowable dimensions of the plot. The final image will exactly match one of these and will not exceed the other.
	}
	\item{units}{
		Character, giving units for the dimensions. Must be recognized by both \code{\link[grDevices]{png}} and \code{grid::\link[grid]{convertUnit}}, so possible values are probably limited to \code{"in"}, \code{"cm"}, \code{"mm"}. Note especially that \code{"px"} does \emph{not} work.
	}
	\item{...}{
		Other arguments passed to \code{png} when setting up the throwaway plot.
	}
}
\details{
	The motivating problem: When making a ggplot with fixed \emph{panel} aspect ratios, the overall dimensions of the full \emph{plot} still depend on the dimensions of other plot elements: axes, legends, titles, etc. In a facetted plot, this gets even trickier: "OK, it has three panels each with aspect ratio 1.5, so that adds up to... wait, does every panel get its own y-axis, or just the leftmost one?".

	\code{\link[ggplot2]{ggplot}} apparently computes absolute dimensions for everything \emph{except} the panels, so the approach taken here is to build the plot inside a throwaway graphical device, subtract off the parts of the image area used by non-panel elements, then divide the remainder up between panels. One dimension will be constrained by the size of the throwaway device, and we can then calculate the other dimension from the panel aspect ratio.

	The biggest known issue with this approach is that it's inefficient, because we have to build the plot twice. I don't know of any way around this. Do you?
}
\value{
	A list containing actual image dimensions \code{height} and \code{width}, both numeric and with the same units as \code{units}.
}
\author{
	Chris Black <chris@ckblack.org>
}
\seealso{
	\code{\link{png_ggsized}} for a convenience wrapper that calculates and plots in one step.
}
\examples{
# Extract dimensions of an existing ggplot object:
a=ggplot(mtcars, aes(wt,mpg))+geom_point()+theme(aspect.ratio=0.75)
d=get_dims(a, maxheight=12, maxwidth=8)
d
# $height
# [1] 6.138644

# $width
# [1] 8

# ==> "Oops, right. we want this plot to be wider than it is tall."

d=get_dims(a, maxheight=8, maxwidth=12)
d
# $height
# [1] 8

# $width
# [1] 10.48181

# Can now use these dimensions to set up correctly-shaped graphics output
\dontrun{
png("plot_of_a.png", height=d$height, width=d$width)
plot(a)
dev.off()
}
}