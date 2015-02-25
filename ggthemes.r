theme_ggEHD = function(base_size=18, ...){
	(theme_bw(base_size=base_size) %+% theme(
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		rect = element_rect(size=rel(0.75)),
		line = element_line(size=rel(1)),
		axis.ticks.length = unit(-(base_size*0.5), "points"),
		axis.ticks.margin = unit((base_size*1.5), "points"),
		plot.margin = unit(base_size*c(1,1,1,1), "points"),
		text=element_text( # Can we inherit some of these?
			family="",
			face="plain",
			size=base_size,
			hjust=0.5,
			vjust=0.5,
			angle=0),
		axis.title.x=element_text(vjust=-1),
		axis.title.y=element_text(vjust=2),
		aspect.ratio=0.75,
		...
	))
}
