png_ggsized = function(
		ggobj,
		filename,
		maxheight=4,
		maxwidth=4,
		res=300,
		units="in",
		...){
	.Deprecated(new="ggsave_fitmax", package="DeLuciatoR")
	dims = get_dims(
		ggobj=ggobj,
		maxheight=maxheight,
		maxwidth=maxwidth,
		units=units,
		...)
	png(
		filename=filename,
		height=dims$height,
		width=dims$width,
		res=res,
		units=units, ...)
	invisible(plot(ggobj))
	dev.off()
}