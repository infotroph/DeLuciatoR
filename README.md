# DeLuciatoR

A few tools to help the DeLucia lab make R plots look the way Evan wants them. Improvements encouraged.

Basic goals, not all of which are implemented yet:

* All text and markings large enough to be *easily* readable when reduced to a tiny subfigure or crammed into a low-rez powerpoint slide.
* 1.33:1 aspect ratio (Y axis 3/4 as tall as X axis is long).
* Ticks on all sides, facing inward.
* Y-axis numbers set horizontally.
* Colors, if any, should be interpretable by dichromats and by those who printed the paper in black and white. 

Currently provides one ggplot2 theme optimized for single-panel X-Y plots. Please help me add others. Let's add some for Lattice approaches... and for plain old base graphics too!

To provide ticks on all sides of a ggplot, I rely on some hacky code that mirrors the axes after the rest of the plot is constructed. I will eventually polish this up and make it available as a freestanding R package; for now, [grab it from GitHub]((https://github.com/infotroph/ggplot-ticks) and do what you like with it.
