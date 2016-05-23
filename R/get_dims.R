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

	# Our approach relies on the quirk that
	# grid::convertUnit treats null units as 0.
	# If this changes, it will be rewrite time.
	stopifnot(grid::convertUnit(unit(1, "null"), "in", "x", valueOnly=T) == 0)

	# This sum gives the dimensions filled by *fixed-size* grobs.
	# We'll divide the remaining available space between rows/columns
	# in proportion to their size in null units.
	known_ht = sum(grid::convertHeight(g$heights, units, valueOnly=TRUE))
	known_wd = sum(grid::convertWidth(g$widths, units, valueOnly=TRUE))

	free_ht = maxheight - known_ht
	free_wd = maxwidth - known_wd

	# Find rows & columns specified in null units.
	# This is a convoluted process because unit names are potentially many layers deep in
	# unit.arithmetic or unit.list objects. Rather than access them directly, we'll compute
	# fixed dimensions twice, once as normal and once after replacing all the null units
	# with inches. Then the difference between these, even though reported as inches,
	# is the dimension in nulls.
	all_null_rowhts = (grid::convertHeight(.null_as_if_inch(g$heights), "in", valueOnly=TRUE)
		- grid::convertHeight(g$heights, "in", valueOnly=TRUE))
	all_null_colwds = (grid::convertWidth(.null_as_if_inch(g$widths), "in", valueOnly=TRUE)
		- grid::convertWidth(g$widths, "in", valueOnly=TRUE))
	null_rowhts = all_null_rowhts[all_null_rowhts > 0]
	null_colwds = all_null_colwds[all_null_colwds > 0]

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
	# print(c("max_rowhts: ", max_rowhts, " max_colwds: ", max_colwds))
		
	rowhts_if_maxwd = max_colwds[1] * panel_asps[,1]
	colwds_if_maxht = max_rowhts[1] / panel_asps[1,]
	# print(c("rowhts_if_maxwd: ", rowhts_if_maxwd, " colwds_if_maxht: ", colwds_if_maxht))

	height = min(maxheight, known_ht + sum(rowhts_if_maxwd))
	width = min(maxwidth, known_wd + sum(colwds_if_maxht))

	return(list(height=height, width=width))
}

# Internal helper function:
# Treat all null units in a unit object as if they were inches.
# This is a bad idea in gneral, but I use it here as a workaround.
# Extracting unit names from non-atomic unit objects is a pain,
# so questions like "which rows of this table layout have null heights?"
# are hard to answer. To work around it, I exploit an (undocumented!)
# quirk: When calculating the size of a table layout inside a Grid plot,
# convertUnit(...) treats null units as zero.
# Therefore
#	(convertHeight(grob_height, "in", valueOnly=TRUE)
#	- convertHeight(null_as_if_inch(grob_height), "in", valueOnly=TRUE))
# does the inverse of convertUnit: It gives the sum of all *null* heights
# in the object, treating *fixed* units as zero.
#
# Warning: I repeat, this approach ONLY makes any sense if
#	convertUnit(unit(1, "null"), "in", "x", valueOnly=T) == 0
# is true. Please check that it is before calling this code.
.null_as_if_inch = function(u){
	if(!grid::is.unit(u)) return(u)
	if(is.atomic(u)){
		if("null" %in% attr(u, "unit")){
			d = attr(u, "data")
			u = unit(
				x=as.vector(u),
				units=gsub("null", "in", attr(u, "unit")),
				data=d)
		}
		return(u)
	}
	if(inherits(u, "unit.arithmetic")){
		l = .null_as_if_inch(u$arg1)
		r = .null_as_if_inch(u$arg2)
		if(is.null(r)){
			args=list(l)
		}else{
			args=list(l,r)
		}
		return(do.call(u$fname, args))
	}
	if(inherits(u, "unit.list")){
		return(do.call(grid::unit.c, lapply(u, .null_as_if_inch)))
	}
	return(u)
}
