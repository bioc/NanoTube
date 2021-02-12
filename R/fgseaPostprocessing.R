#' Postprocessing for GSEA analyses
#'
#' Clusters GSEA results by leading edge genes, and writes reports showing
#' gene expression profiles of these genes.
#'
#' @param genesetResults Results from pathway analysis using limmaToFGSEA.
#' @param leadingEdge Results from fgseaToLEdge
#' @param join.threshold The threshold distance to join gene sets. Gene sets with a distance
#' below this value will be joined to a single "cluster."
#' @param ngroups The desired number of gene set groups. Either 
#' 'join.threshold' or 'ngroups' must be specified, 'ngroups' takes priority 
#' if both are specified.
#' @param dist.method Method for distance calculation (see options for dist()).
#' We recommend the 'binary' (also known as Jaccard) distance.
#' @param filename File name for the output text file. If NULL (default), data will be returned
#' as an R data frame.

fgseaPostprocessing <- function(genesetResults, leadingEdge, limmaResults,
                               join.threshold = 0.5, ngroups = NULL,
                               dist.method = "binary", reportDir) {

  dir.create(reportDir, showWarnings = FALSE)

  makeFGSEAmasterTable(genesetResults, leadingEdge,
                        join.threshold, filename = paste0(reportDir, "/gsea_summary.txt"))

  for (i in names(genesetResults)) {
      if(!is.null(leadingEdge[[i]])){
        grouped <-   groupFGSEA(genesetResults[[i]],
                                     leadingEdge[[i]],
                                     join.threshold,
                                     ngroups, dist.method,
                                     returns = "signif")
        tab <- groupedGSEAtoStackedReport(grouped, leadingEdge[[i]], limmaResults)
        
        write.table(tab, file = paste0(reportDir, "/", i, ".txt"),
                    sep = "\t", quote = FALSE, 
                    row.names = FALSE, col.names = TRUE)
}
  }

}