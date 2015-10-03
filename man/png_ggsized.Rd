\name{png_ggized}
\alias{png_ggsized}
\title{
	Save ggplot to correctly-shaped PNG
}
\description{
	When a ggplot has a fixed \emph{panel} aspect ratio, it can be a pain to find the right dimensions for the whole \emph{plot} (including axes, margins, legends, etc) when saving it to a fixed-size graphical device. png_ggized takes a ggplot object and saves it as the largest PNG that fits inside the specified \emph{maximum} height and width.
}
\usage{
	png_ggsized(ggobj, filename, 
		maxheight=4, maxwidth=4,
		res=300, units="in", \dots)
}
\arguments{
	\item{ggobj}{
		A \code{\link[ggplot2]{ggplot}} or \code{\link[gtable]{gtable}} object.
	}
	\item{filename}{
		Name for the output image; see \code{\link[grDevices]{png}}. 
	}
	\item{maxheight, maxwidth}{
		Numeric, giving argest allowable dimensions of the plot. The final image will exactly match one of these and will not exceed the other. 
	}
	\item{units}{
		Character, giving units for the dimensions. Must be recognized by both \code{\link[grDevices]{png}} and \code{grid::\link[grid]{convertUnit}}, so possible values are probably limited to \code{"in"}, \code{"cm"}, \code{"mm"}. Note especially that \code{"px"} does \emph{not} work.
	}
	\item{res}{
		Numeric. The nominal resolution, in ppi, for the outpuf file; see \code{\link[grDevices]{png}}.
	}
	\item{\dots}{
		Other arguments passed to \code{png}.
	}
}
\details{
	This is a convenience function that wraps three distinct steps: Lookng up the plot dimensions using \code{\link{get_dims}}, opening a new PNG using \code{\link[grDevices]{png}}, then writing the image with a simple \code{plot(ggobj)}. If you need more flexibility in any of these steps, skip this wrapper and use them directly; see the examples in \code{\link{get_dims}} for an example.

	The dimension lookup was motivated by the difficulty of predicting image height & width when the panels have a fixed aspect ratio, but this wrapper \emph{should} work as a one-call plotting command for plots with unconstrained ratios as well. Please report any that don't work.
}
\note{
	Converting pixel dimensions into nominal physical dimensions requires that everyone involved agree what pixel-per-inch resolution they are using, but some PNG viewers ignore the embedded resolution and report physical dimensions from their own assumed ppi. This function can't fix that, but it does use the right pixel dimensions for the resolution you specify.
}
\author{
	Chris Black <chris@ckblack.org>
}
\examples{
\dontrun{
a=ggplot(mtcars, aes(wt,mpg))+geom_point()+theme(aspect.ratio=0.75)

# Saves a.png at 3144 x 2400 px 
# == (nominally!) 10.48 x 8 inches at 300 ppi.
png_ggized(a, filename="a.png", maxheight=8, maxwidth=12)

# Saves aa.png at 1172 x 900 px
# == 7.8 x 6 inches at 150 ppi... or 3.9 x 3 inches at 300 ppi, or...
png_ggsized(a, filename="aa.png", maxheight=6, maxwidth=9, res=150)
}
}