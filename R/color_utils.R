#' @importFrom scales brewer_pal grey_pal
col_check2 <- function(geom.colors, collen) {
  # --------------------------------------------
  # check color argument
  # --------------------------------------------
  # check for corrct color argument
  if (!is.null(geom.colors)) {
    # check for color brewer palette
    if (is.brewer.pal(geom.colors[1])) {
      geom.colors <- scales::brewer_pal(palette = geom.colors[1])(collen)
    } else if (is.sjplot.pal(geom.colors[1])) {
      geom.colors <- get_sjplot_colorpalette(geom.colors[1], collen)
    } else if (is.wes.pal(geom.colors[1])) {
      geom.colors <- get_wesanderson_colorpalette(geom.colors[1], collen)
    } else if (geom.colors[1] %in% c("v", "viridis")) {
      geom.colors <- get_viridis_colorpalette(collen)
      # do we have correct amount of colours?
    } else if (geom.colors[1] == "gs") {
      geom.colors <- scales::grey_pal()(collen)
      # do we have correct amount of colours?
    } else if (geom.colors[1] == "bw") {
      geom.colors <- rep("black", times = collen)
      # do we have correct amount of colours?
    } else if (length(geom.colors) > collen) {
      # shorten palette
      geom.colors <- geom.colors[1:collen]
    } else if (length(geom.colors) < collen) {
      # repeat color palette
      geom.colors <- rep(geom.colors, times = collen)
      # shorten to required length
      geom.colors <- geom.colors[1:collen]
    }
  } else {
    geom.colors <- scales::brewer_pal(palette = "Set1")(collen)
  }

  geom.colors
}


# check whether a color value is indicating
# a color brewer palette
is.brewer.pal <- function(pal) {
  bp.seq <- c("BuGn", "BuPu", "GnBu", "OrRd", "PuBu", "PuBuGn", "PuRd", "RdPu",
              "YlGn", "YlGnBu", "YlOrBr", "YlOrRd", "Blues", "Greens", "Greys",
              "Oranges", "Purples", "Reds")
  bp.div <- c("BrBG", "PiYG", "PRGn", "PuOr", "RdBu", "RdGy", "RdYlBu",
              "RdYlGn", "Spectral")
  bp.qul <- c("Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1",
              "Set2", "Set3")
  bp <- c(bp.seq, bp.div, bp.qul)
  pal %in% bp
}


is.sjplot.pal <- function(pal) {
  pal %in% names(sjplot_colors)
}


is.wes.pal <- function(pal) {
  pal %in% c("GrandBudapest", "Moonrise1", "Royal1", "Moonrise2", "Cavalcanti", "Royal2",
             "GrandBudapest2", "Moonrise3", "Chevalier", "Zissou", "FantasticFox",
             "Darjeeling", "Rushmore", "BottleRocket", "Darjeeling2")
}


get_wesanderson_colorpalette <- function(pal, len) {
  if (!requireNamespace("wesanderson", quietly = TRUE)) {
    warning("Package `wesanderson` required for this color palette.", call. = F)
    return(NULL)
  }

  wesanderson::wes_palette(name = pal, n = len)
}


get_viridis_colorpalette <- function(len) {
  if (!requireNamespace("viridis", quietly = TRUE)) {
    warning("Package `viridis` required for this color palette.", call. = F)
    return(NULL)
  }

  viridis::viridis(n = len)
}


get_sjplot_colorpalette <- function(pal, len) {
  col <- sjplot_colors[[pal]]

  if (len > length(col)) {
    warning("More colors requested than length of color palette.", call. = F)
    len <- length(col)
  }

  col[1:len]
}
