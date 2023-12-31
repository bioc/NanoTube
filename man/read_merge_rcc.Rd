% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_merge_rcc.R
\name{read_merge_rcc}
\alias{read_merge_rcc}
\title{Merge multiple .rcc files}
\usage{
read_merge_rcc(fileList, includeQC = FALSE, logfile = "")
}
\arguments{
\item{fileList}{a character vector of .rcc file names}

\item{includeQC}{include merged QC data (from the "Lane Attributes" part of 
file) in the output? Default FALSE}

\item{logfile}{a filename for the logfile (optional). If blank, will print 
warnings to screen.}
}
\value{
A list object including:
\item{exprs}{The expression matrix}
\item{dict}{The gene dictionary}
\item{qc}{QC metrics included in the .rcc files, if includeQC == TRUE}
}
\description{
Read in multiple .rcc files named in the fileList and merge the expression 
data. This step is conducted within processNanostringData.
}
\examples{
example_data <- system.file("extdata", "GSE117751_RAW", package = "NanoTube")

dat <- read_merge_rcc(list.files(example_data, full.names = TRUE))
}
