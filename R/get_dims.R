# Given a plot with fixed *panel* aspect ratios, find dimensions that
# fit the *whole plot* inside a given maximum height and width.

get_dims = function(ggobj, maxheight, maxwidth=maxheight, units="in", ...){

	# Check for common cases where plot ratios are unconstrained
	# ==> don't need to build anything, can infer that the plot will
	# fill the whole area.
	if(inherits(ggobj, "ggplot")
			&& !isTRUE(ggobj$respect)
			&& is.null(ggobj$theme$aspect.ratio)
			&& is.null(ggobj$coordinates$ratio)
			&& is.null(theme_get()$aspect.ratio)){
		return(list(height=maxheight, width=maxwidth))
	}

	# Open a temporary plotting device to do the calculations inside.
	# This is for two reasons: Ultimately because unit conversions
	# are device-dependent, but proximally because otherwise Grid will
	# open one for us and leave it open for the user to deal with.
	tmpf = tempfile(pattern="dispos-a-plot", fileext= ".png")
	png(
		filename=tmpf,
		height=maxheight,
		width=maxwidth,
		units=units,
		res=120,
		...)
	on.exit({dev.off(); unlink(tmpf)})

	# Supported plot types: Supposedly handles anything ggplot can produce.
	# Probably works on other gtables, e.g. gridExtra::arrangeGrob,
	# but these are less tested. TODO: Lattice output?
	if(inherits(ggobj, "ggplot")){
		g = ggplotGrob(ggobj)
	}else if (inherits(ggobj, "gtable")){
		g = ggobj
	}else{
		stop("Don't know how to get sizes for object of class ",
			deparse(class(ggobj)))
	}

	# convertUnit treats null units as 0,
	# so this sum gives the dimensions filled by *fixed-size* grobs.
	# We'll divide the remaining available space between rows/columns
	# in proportion to their size in null units.
	known_ht = sum(grid::convertHeight(g$heights, units, valueOnly=TRUE))
	known_wd = sum(grid::convertWidth(g$widths, units, valueOnly=TRUE))

	free_ht = maxheight - known_ht
	free_wd = maxwidth - known_wd

	# Find rows & columns specified in null units. 
	# TODO: handle nulls inside unit.arithmetic, e.g. "1null+3cm", or not?
	# Could arise from user arguments to gtable or gridExtra::arrangeGrob,
	# but both seem buggy (null part ignored?) even without a get_dims call.
	null_rowhts = c(unlist(g$heights[grepl("null", g$heights)]))
	null_colwds = c(unlist(g$widths[grepl("null", g$widths)]))
	
	panel_asps = matrix(null_rowhts, ncol=1) %*% matrix(1/null_colwds, nrow=1)

	# Handle cases where height or width is fully determined. 
	# TODO: Incomplete! As written, these cases have a zero-element panel_asps
	# that throws "subscript out of bounds" in the *_if_max* calculations.
	# Need to understand how aspect ratios should (/actually do) work
	# when only one side is in null units. Does g$respect change behavior?
	# 
	# Maybe: If height fixed and width has nulls, return list(min(maxheight, known_ht), max_colwds)?
	# if(length(null_rowhts) == 0){
	# 	# All rows have fixed height, compute
	# 	maxheight = min(maxheight, known_ht)
	# 	free_ht = 0
	# 	max_rowhts = g$heights
	# }
	# if(length(null_rowhts) == 0){
	# 	# All cols have fixed width
	# 	maxwidth = min(maxwidth, known_wd)
	# 	free_wd = 0
	# 	max_colwds = g$widths
	# }

	max_rowhts = free_ht / sum(null_rowhts) * null_rowhts
	max_colwds = free_wd / sum(null_colwds) * null_colwds
	
		
	rowhts_if_maxwd = max_colwds[1] * panel_asps[,1]
	colwds_if_maxht = max_rowhts[1] / panel_asps[1,]

	height = min(maxheight, known_ht + sum(rowhts_if_maxwd))
	width = min(maxwidth, known_wd + sum(colwds_if_maxht))

	return(list(height=height, width=width))
}