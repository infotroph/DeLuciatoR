\name{ggsave_fitmax}
\alias{ggsave_fitmax}
\title{
	Save ggplot to correctly-shaped image file
}
\description{
	When a ggplot has a fixed \emph{panel} aspect ratio, it can be a pain to find the right dimensions for the whole \emph{plot} (including axes, margins, legends, etc) when saving it to a fixed-size graphical device. ggsave_fitmax takes a ggplot object and saves it as the largest image that fits inside the specified \emph{maximum} height and width.
}
\usage{
	ggsave_fitmax(filename, plot=last_plot(), 
		maxheight=7, maxwidth=maxheight,
		units="in", \dots)
}
\arguments{
	\item{filename}{
		Name for the output image. By default the image format is guesssed from the file extension, but this can be overridden by specifying a value for \code{device}. See \code{\link{ggsave}} for details.
	}
	\item{plot}{
		A \code{\link[ggplot2]{ggplot}} or \code{\link[gtable]{gtable}} object. Defaults to the last plot displayed.
	}
	\item{maxheight, maxwidth}{
		Numeric, giving largest allowable dimensions of the plot. The final image will exactly match one of these and will not exceed the other. 
	}
	\item{units}{
		One of \code{"in"}, \code{"cm"}, \code{"mm"}, giving units for the dimensions. Note that \code{"px"} does \emph{not} work.
	}
	\item{\dots}{
		Other arguments passed to \code{\link{ggsave}}, notably including \code{dpi} (to set pixel resolution of the output image) and \code{limitsize} (set to FALSE if you really do want an image larger than 50 inches).
	}
}
\details{
	This is a convenience function that wraps two distinct steps: Looking up the plot dimensions using \code{\link{get_dims}}, and saving the image using \code{\link{ggsave}}. If you need more flexibility in either step, skip this wrapper and call \code{get_dims} directly, then pass the computed dimensions to your favorite graphics device. See the examples in \code{\link{get_dims}} for an example.

	The dimension lookup was motivated by the difficulty of predicting image height & width when the panels have a fixed aspect ratio, but this wrapper \emph{should} work as a one-call plotting command for plots with unconstrained ratios as well. Please report any that don't work.
}
\note{
	For pixel-based formats such as PNG, the conversion between pixels and physical inch/mm dimensions is more complicated that it sounds. In particular, some image viewers will treat a high-dpi image as a very large but low-dpi image. See the "Details" section of \code{\link[grDevices]{png}} for more, but the upshot is that \code{ggsave_fitmax} always produces a raster image containing the right number of pixels to produce the requested physical dimensions \emph{if} displayed at the specified dpi.
}
\author{
	Chris Black <chris@ckblack.org>
}
\examples{
\dontrun{
a=ggplot(mtcars, aes(wt,mpg))+geom_point()+theme(aspect.ratio=0.75)

# Saves a.pdf at 10.55 x 8 inches
ggsave_fitmax(filename="a.pdf", plot=a, maxheight=8, maxwidth=12)

# Saves a.png at 3163 x 2400 px 
# == (nominally!) 10.55 x 8 inches at 300 ppi.
ggsave_fitmax(filename="a.png", plot=a, maxheight=8, maxwidth=12)

# Saves aa.jpg at 1181 x 900 px
# == 7.8 x 6 inches at 150 ppi... or 3.9 x 3 inches at 300 ppi, or 16.4 x 12.5 at 72 ppi, or...
ggsave_fitmax(filename="aa.jpg", plot=a, maxheight=6, maxwidth=9, dpi=150)

}
}