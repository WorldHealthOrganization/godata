
#' This function uses `binom.test` to derive estimates of the 95% CI for
#' proportions.
#'
#' @param k number of successes
#'
#' @param n number of trials
#'
#' @param conf confidence level, defaults to 0.95
#'
#' @param result a `character` vector indicating which bounds of the confidence
#'   interval to return: can be `"lower"`, or `"upper"`, or `"both"`
#'
#' @param perc a `logical` indicating if results should be formatted as
#'   percentages, rounded to 2 decimal places, or not (defaults to `FALSE`)
#'
#' @param dec the number of decimal places used for rounding percentages
#'
#' @author Thibaut Jombart
#' 

prop_ci <- function(k, n,
                    result = c("both", "lower", "upper"),
                    perc = FALSE,
                    conf = 0.95,
                    dec = 2) {
  if(n == 0){
    out = c(0,1)
  } else{
    out <- binom.test(k, n, conf.level = conf)$conf.int
    result <- match.arg(result)
  }
  if (result == "both") {
    result <- c("lower", "upper")
  }
  names(out) <- c("lower", "upper")
  out <- out[result]
  
  if (perc) {
    out <- round(100 * out, dec)
  }
  out
}

prop_ci <- Vectorize(prop_ci)




#' Compute standardised chi2 residuals
#'
#' @param x a table as returned by `table`, or a matrix
                                        
chi2_residuals <- function(x) {
  if (!all(dim(x) > 0)) {
    stop("x must have 2 positive dimensions")
  }
  observed <- x
  expected <- matrix(rowSums(x)) %*% t(colSums(x)) / sum(x)
  (observed - expected) / sqrt(expected)
}



#' Plot chi2 residuals
#'
#' @param x a table as returned by `table`, or a matrix

plot_chi2_residuals <- function(x) {
  df <- as.data.frame(chi2_residuals(x))
  df$size <- abs(df$Freq)

  type_residual <- with(df,
                        case_when(Freq < -4 ~ "much less",
                                  Freq < -2 ~ "less",
                                  Freq < 2 ~ "normal",
                                  Freq < 4 ~ "more",
                                  TRUE ~ "much more"))

  df$category <- factor(type_residual,
                        levels = c("much more",
                                   "more",
                                   "normal",
                                   "less",
                                   "much less"))
                        
  scale_color_category <- scale_color_manual(
      "Deviation",
      values = c(`much less` = "#cc0000",
                 less = "#ff9999",
                 normal = "#8c8c8c",
                 more = "#b3cce6",
                 `much more` = "#336699"))

  ggplot(df,
         aes_string(x = names(df)[1],
                    y = names(df)[2],
                    color = "category",
                    size = "size")) +
    geom_point() +
    scale_color_category +
    scale_size(range = c(0, 20), guide = FALSE) +
    guides(color = guide_legend(override.aes = list(size = 3)))
  
}

