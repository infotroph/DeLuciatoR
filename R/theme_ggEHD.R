theme_ggEHD = function(base_size=18, base_family=""){
	thm = (theme_bw(base_size=base_size, base_family=base_family) %+% theme(
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		rect = element_rect(size=rel(0.75)),
		line = element_line(size=rel(1)),
		axis.line = element_line(size=rel(1)),
		axis.ticks = element_line(size=rel(1)),
		axis.ticks.length = unit(-(base_size*0.5), "points"),
		plot.margin = unit(base_size*c(1,1,1,1), "points"),
		text=element_text( # Can we inherit some of these?
			family=base_family,
			face="plain",
			size=base_size,
			color="black",
			hjust=0.5,
			vjust=0.5,
			angle=0),
		axis.text=element_text(size=rel(0.8), color = "black"),
		axis.title.x=element_text(vjust=-1),
		axis.title.y=element_text(vjust=2),
		aspect.ratio=0.75
	))

	if(packageVersion("ggplot2") >= 2.0){
		return(thm %+% theme(
			axis.text.x = element_text(margin=margin(t=base_size*1.5, unit="points")),
			axis.text.y = element_text(margin=margin(r=base_size*1.5, unit="points"))))
	}else{
		return(thm %+% theme(
			axis.ticks.margin = unit((base_size*1.5), "points")))
	}
}
