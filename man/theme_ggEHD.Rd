\name{theme_ggEHD}
\alias{theme_ggEHD}
\title{
DeLucia lab ggplot2 theme
}
\description{
Style ggpplot2 elements to provide the format Evan most commonly requests. Actual Evan-approval of the result is not guaranteed.
}
\usage{
	theme_ggEHD(base_size=18, ...)
}
\arguments{
	\item{base_size}{
		Base font size for the theme, in points.
	}
	\item{...}{
		Other arguments passed to \code{\link[ggplot2]{theme}}.
	}
}
\value{
	a complete theme based on \code{\link{theme_bw}}.
}
\author{
	Chris Black <chris@ckblack.org>
}
\seealso{
	\code{\link[ggplot2]{theme}} for a list of the possible theme elements; the \href{http://docs.ggplot2.org/dev/vignettes/themes.html}{ggplot2 themes vignette} for details on using the theme system.
}
\examples{
library(ggplot2)

carplot = (ggplot(mtcars, aes(wt, mpg))
	+geom_smooth(method="lm", linetype="dotted")
	+geom_point()
	+xlab("Vehicle weight (k lb)")
	+ylab("MPG"))

# Ideal base_size will differ depending on your target resolution.
carplot_screen = carplot + theme_ggEHD(12)
carplot_poster = carplot + theme_ggEHD(32)

# Adding theme_ggEHD() replaces all existing theme information.
# To alter theme elements, add them downstream of theme_ggEHD.
carplot_stretched = carplot + theme_ggEHD(12) + theme(aspect.ratio=0.25)
}