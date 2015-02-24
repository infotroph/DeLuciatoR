theme_ggEHD = function(...){
	(theme_bw() %+% theme(
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.ticks.length = unit(-0.75, "lines"),
		axis.ticks.margin = unit(1.5, "lines"),
		text=element_text( # Can we inherit some of these?
			family="",
			face="plain",
			size=18,
			hjust=0.5,
			vjust=0.5,
			angle=0),
		axis.title=element_text(vjust=0.3),
		aspect.ratio=0.75,
		...
	))
}