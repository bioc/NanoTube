#' Calculate positive control statistics
#'
#' Calculate the linearity and scale factors of positive control genes, and
#' plot the expected vs. observed counts for each sample.
#'
#' @param ns NanoString data, processed by `processNanostringData` with
#' normalization set to 'none' or with output.format set to 'list'.
#' @param samples A subset of samples to analyze (either a vector of sample names,
#' or column indexes). If NULL (default), will include all samples.
#' @param expected The expected values of each positive control gene, as a 
#' numeric vector. These are frequently provided by NanoString in the 'Name' 
#' field of the genes, in which case those values will be read automatically 
#' and this option can be left as NULL (the default).
#' @return A list containing:
#' \item{tab}{The table of positive control statistics, included the positive
#' scale factor and the R-squared value for the expected vs. measured counts}
#' \item{plt}{An object containing the positive control plots. This gets
#' cumbersome if there are lots of samples.}

positiveQC <- function(ns, samples = NULL, expected = NULL) {
  
  #Log-transform the expected values if provided.
  if (!is.null(expected)) {
    expected <- log2(expected)
  }
  
  if (class(ns) == "list") {
    dat.pos <- as.data.frame(log2(ns$exprs.raw[ns$dict.raw$CodeClass == "Positive",]))
    
    # Identify the expected value for each positive control
    if (is.null(expected)) {
      expected <- log2(as.numeric(gsub(".*\\(|\\)", "", ns$dict.raw$Name[ns$dict.raw$CodeClass == "Positive"])))
    }
    
  } else {
    if (ns$normalization[1] != "none") {
      stop("Raw NanoString data must be provided. Use normalization='none'
         or output.format='list' in `processNanostringData`.")
    }
    dat.pos <- as.data.frame(log2(exprs(ns)[fData(ns)$CodeClass == "Positive",]))
    
    # Identify the expected value for each positive control
    if (is.null(expected)) {
      expected <- log2(as.numeric(gsub(".*\\(|\\)", "", fData(ns)$Name[fData(ns)$CodeClass == "Positive"])))
    }
  }
  
  
  # Use a subset of samples, if indicated
  if (!is.null(samples)) {
    dat.pos <- dat.pos[,samples]
  }
  
  # Calculate positive scale factors
  laneGM <- sapply(dat.pos, gm_mean)
  scale.factor <- laneGM / mean(laneGM)
  
  # Calculate r-squared for each sample
  rsq <- sapply(dat.pos, function(vec) cor(vec, expected) ^ 2)
  
  dat.pos$Expected <- expected
  
  dat.pos.df <- reshape::melt(dat.pos, "Expected")
  colnames(dat.pos.df)[2:3] <- c("Sample", "Observed")
  
  samps <- unique(dat.pos.df$Sample)
  xmin <- min(dat.pos.df$Expected)
  xmax <- max(dat.pos.df$Expected)
  ymin <- min(dat.pos.df$Observed)
  ymax <- max(dat.pos.df$Observed)
  
  pos.height <- (ncol(dat.pos)-1) * 2/3
  
  # Scale factor table
  pos.tab <- data.frame(Sample = colnames(dat.pos)[-ncol(dat.pos)],
                        Scale.Factor = scale.factor,
                        R.squared = rsq)
  
  pos.plot <- ggplot(data=dat.pos.df, aes(x=Expected, y=Observed)) +
    geom_point(colour = "black", fill = "grey70", pch=21, size=3) + 
    facet_wrap(~ Sample, ncol = 3) + 
    xlim(xmin, xmax) + ylim(ymin, ymax) + theme_bw()
  
  return(list(tab = pos.tab,
              plt = pos.plot))
}