#' Calculate the geometric mean
#'
#' Calculates the geometric mean of a numeric vector
#'
#' @param x A numeric vector
#' @param na.rm Logical (default TRUE). Should NA values be ignored in this calculation? If FALSE,
#' a vector containing NA values will return a geometric mean of NA.
#' @return The geometric mean

gm_mean = function(x, na.rm=TRUE){
  exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
}