
## produce only integer breaks
int_breaks <- function(x, n = 5) {
  pretty(x, n)[pretty(x, n) %% 1 == 0]
}


## make text bigger on ggplot2 plots
large_txt <- ggplot2::theme(text = ggplot2::element_text(size = 16),
                            axis.text = ggplot2::element_text(size = 14))
smaller_axis_txt <- ggplot2::theme(axis.text = ggplot2::element_text(size = 10))


## dark color palette
dark_pal <- colorRampPalette(c("#800080", "#4d0099", "#5c5c8a", "#006666",
                                "#527a7a", "#006600", "#999900", "#999966",
                                "#996633", "#b35900", "#cc7a00", "#cc4400",
                                "#993333", "#009999", "#666666"))

## Custom chord diagram
## `x` is a data.frame with 3 columns: from, to, frequency
## `pal` is a color palette
## `gap` is the size of the gap between sections
## `label_space` is the extra space to plot label
 
circle_plot <- function(x, pal = dark_pal, gap = 5,
                        label_space = 1.75, ...) {
  if (!require(circlize)) {
    stop("Package circlize is needed")
  }

  ## reset graphics par on exit
  on.exit(circos.clear())

  ## make colors
  all_sections <- levels(unlist(x[1:2]))
  n_sections <- length(all_sections)
  sections_col <- pal(n_sections)
  names(sections_col) <- all_sections

  ## set global params
  circos.par(gap.after = gap)

  ## make basic graph
  chordDiagram(x,
               annotationTrack = "grid",
               preAllocateTracks =
                 list(track.height =
                        label_space * max(strwidth(unlist(dimnames(x))))),
               grid.col = sections_col, ...)

  ## add annotations
  circos.track(track.index = 1,
               panel.fun = function(x, y) {
                 circos.text(CELL_META$xcenter,
                             CELL_META$ylim[1],
                             CELL_META$sector.index, 
                             facing = "clockwise",
                             niceFacing = TRUE,
                             adj = c(0, 0.5),
                             cex = 1.2)
               }, bg.border = NA)

}




scale_months <- ggplot2::scale_x_date(breaks = "1 month",
                                      date_label = format("%d %b %Y"))


scale_weeks <- ggplot2::scale_x_date(breaks = "1 week",
                                     date_label = format("%d %b %Y"))


## psychedelic
funky <- colorRampPalette(c("#A6CEE3","#1F78B4","#B2DF8A",
                            "#33A02C","#FB9A99","#E31A1C",
                            "#FDBF6F","#FF7F00","#CAB2D6",
                            "#6A3D9A","#FFFF99","#B15928"))



## strips for vertical facetting: horizontal labels, nice colors
custom_vert_facet <- theme(
    strip.text.y = element_text(size = 12, angle = 0, color = "#6b6b47"),
    strip.background = element_rect(fill = "#ebebe0", color = "#6b6b47"))

custom_horiz_facet <- theme(
    strip.text.x = element_text(size = 12, angle = 90, color = "#6b6b47"),
    strip.background = element_rect(fill = "#ebebe0", color = "#6b6b47"))
