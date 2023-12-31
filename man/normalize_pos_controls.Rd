% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalize_pos_controls.R
\name{normalize_pos_controls}
\alias{normalize_pos_controls}
\title{Positive control gene normalization}
\usage{
normalize_pos_controls(dat, logfile = "")
}
\arguments{
\item{dat}{NanoString data, including expression matrix and gene dictionary.}

\item{logfile}{Optional name of logfile to print messages, warnings or 
errors.}
}
\value{
NanoString data, with expression matrix now normalized by 
positive control gene expression.
}
\description{
Scale genes by the geometric mean of positive control genes. This step is
conducted within processNanostringData, when normalization is set to 
"nCounter".
}
\examples{
example_data <- system.file("extdata", "GSE117751_RAW", package = "NanoTube")

dat <- read_merge_rcc(list.files(example_data, full.names = TRUE))

# Positive controls are identified in the RCC files, and used to 
# normalize the data
dat <- normalize_pos_controls(dat)
}
