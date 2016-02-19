get_dims = function(ggobj, maxheight, maxwidth=maxheight, units="in", ...){

	 # open a plotting device to do the calculations inside
	tmpf = tempfile(pattern="dispos-a-plot", fileext= ".png")
	png(filename=tmpf, height=maxheight, width=maxwidth, units=units, res=120, ...)
	on.exit({dev.off(); unlink(tmpf)})

	# These values do not reliably give the real aspect ratio,
	# but if both are unset then the ratio is unconstrained and we
	# can exit without building--the plot will fill the whole area.
	if (inherits(ggobj, "ggplot")
			&& is.null(ggobj$theme$aspect.ratio)
			&& is.null(ggobj$coordinates$ratio)){
		return(c(height=maxheight, width=maxwidth))}

	if(inherits(ggobj, "ggplot")){
		g = ggplot_gtable(ggplot_build(ggobj))
	}else if ("gtable" %in% class(ggobj)){
		g = ggobj
	}else{
		stop(paste(
			"Don't know how to get sizes for object of class",
			class(ggobj)))
	}

	panel_layout = g$layout[grepl("panel", g$layout$name),]
	n_rows = length(unique(panel_layout$t))
	n_cols = length(unique(panel_layout$l))

	# panels have unit "null", but they carry ratio information anyway.
	if(inherits(g$widths, "unit.list")){
		# any plot from ggplot2 v1.0.x, facet_null from ggplot2 v2.0.x
		gw_units = sapply(g$widths, attr, "unit")
		gh_units = sapply(g$heights, attr, "unit")
		asp = (unlist(g$heights[gh_units == "null"])
			/ unlist(g$widths[gw_units == "null"]))
	}else if(inherits(g$widths, "unit")){
		# facet_wrap or facet_grid from ggplot2 v2.0.x
		gw_units = attr(g$widths, "unit")
		gh_units = attr(g$heights, "unit")
		asp = (as.numeric(g$heights[gh_units == "null"])
			/ as.numeric(g$widths[gw_units == "null"]))
	}else{
		stop("Don't know how to extract units from class ", class(g$widths))
	}

	if(length(unique(asp)) > 1){
		stop("panels have different aspect ratios?!")}
	asp = asp[1]

	# convertUnit treats null units as 0, 
	# so this sum gives the dimensions of *non-panel* grobs.
	known_hts = sum(grid::convertHeight(g$heights, units, valueOnly=T))
	known_wds = sum(grid::convertWidth(g$widths, units, valueOnly=T))
	free_ht = maxheight - known_hts
	free_wd = maxwidth - known_wds

	# Whew. Now we're ready to calculate image dimensions.
	height = maxheight
	width = ((free_ht / n_rows) / asp * n_cols) + known_wds
	if (width > maxwidth){
		width = maxwidth
		height = ((free_wd / n_cols) * asp * n_rows) + known_hts}

	return(list(height=height, width=width))
}