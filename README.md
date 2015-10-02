# DeLuciatoR

A few tools to help the DeLucia lab make R plots look the way Evan wants them. Improvements encouraged.

Basic goals, not all of which are implemented yet:

- [ ] All text and markings large enough to be *easily* readable when reduced to a tiny subfigure or crammed into a low-rez powerpoint slide. Prtly implemented, needs work.
- [x] 1.33:1 aspect ratio (Y axis 3/4 as tall as X axis is long).
- [ ] Ticks on all sides, facing inward. 'Inward' part is done, 'all sides' part is ugly (see below) and needs more work.
- [x] Y-axis numbers set horizontally.
- [ ] Colors, if any, should be interpretable by dichromats and by those who printed the paper in black and white. Not yet implemented.

Currently provides one ggplot2 theme optimized for single-panel X-Y plots. Please help me add others. Let's add some for Lattice approaches... and for plain old base graphics too!

## Installation

The easy way, in an R session:

```
install.packages("devtools")
install_github("infotroph/DeLuciatoR")
library("DeLuciatoR")
```

The hard way, in a terminal window (you only need to do this if you want to make your own changes to the package):

```
git clone git@github.com:infotroph/DeLuciatoR.git
# Edit any files you like here
R CMD build DeLuciatoR
R CMD check DeLuciator_0.0.1.tar.gz
# If R complains, go back and fix any errors here
R CMD install DeLuciator_0.0.1.tar.gz
```

## That 'ticks on all sides' thing

The ggplot2 package is... Let's say "opinionated"... about whether you should add extra axes to a plot, and therefore provides no easy way to put ticks on all sides. To get around this, I rely on some hacky code that mirrors the axes after the rest of the plot is constructed. I will eventually polish this up and make this package use it automatically; for now, [grab it from GitHub](https://github.com/infotroph/ggplot-ticks) and use it as the last step before plotting:

```
source_url("https://raw.githubusercontent.com/infotroph/ggplot-ticks/master/mirror.ticks.r")
# Or if you keep a local copy, source("path/to/my/mirror.ticks.r")


# This is a *ggplot* object and can be modified all the usual ways
twoticks = ggplot(...)+geom_point()+...+theme_ggEHD()
twoticks+theme(legend.position="none")

# This is a *gtable* object, meaning it:
# 	* Can't be further modified by ggplot functions
# 	* Won't plot automatically; you have to explicitly call plot()
fourticks = mirror.ticks()

png(filename="my_Nature_submission.png", height=4, width=8, units="cm")
plot(fourticks)
dev.off()
```
