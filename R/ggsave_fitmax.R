ggsave_fitmax = function(
			filename,
			plot=last_plot(),
			maxheight=7,
			maxwidth=maxheight,
			units="in",
			...){
	dims = get_dims(
		ggobj=plot,
		maxheight=maxheight,
		maxwidth=maxwidth,
		units=units)
	ggsave(
		filename=filename,
		plot=plot,
		height=dims$height,
		width=dims$width,
		units=units, 
		...)
}