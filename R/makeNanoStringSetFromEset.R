#' Convert NanoString ExpressionSet to NanoStringSet
#'
#' Convert ExpressionSet from processNanoStringData to a NanoStringSet for use
#' with the NanoStringDiff package.
#' 
#' @export
#'
#' @param eset NanoString data ExpressionSet, from processNanostringData
#' @param designs Design matrix. If NULL, will look for "groups" column in 
#' pData(eset).
#' @return A NanoStringSet for NanoStringDiff
#' 
#' @examples 
#' # Example data
#' example_data <- system.file("extdata", "GSE117751_RAW", package = "NanoTube")
#' sample_data <- system.file("extdata", "GSE117751_sample_data.csv", 
#' package = "NanoTube")
#' 
#' # Load data without normalization
#' dat <- processNanostringData(nsFiles = example_data,
#'                      sampleTab = sample_data, groupCol = "Sample_Diagnosis",
#'                      normalization = "none")
#'                      
#' # Convert to NanoStringSet
#' dat.ns <- makeNanoStringSetFromEset(dat)

makeNanoStringSetFromEset <- function(eset, designs = NULL) {
  
    # Order positive control data (required for NanoStringDiff)
    pos.unordered <- eset[grep("positive", fData(eset)$CodeClass, ignore.case = TRUE),]
    pos.ordered <- exprs(pos.unordered)[order(fData(pos.unordered)$Name),]
    
    # Look for group info
    if (is.null(designs)) {
        if ("groups" %in% colnames(pData(eset))) {
            designs <- model.matrix(~0 + eset$groups)
            # Clean up column names
            colnames(designs) <- gsub("eset\\$groups", "", colnames(designs))
        } else {
            stop("Must input design matrix, or include groups 
                 in sample info of eset.")
        }
    }
    
    # Build NanoStringSet
    nsSet <- NanoStringDiff::createNanoStringSet(
        endogenous = exprs(eset)[grep("endogenous", fData(eset)$CodeClass, ignore.case = TRUE),],
        positiveControl = pos.ordered,
        negativeControl = exprs(eset)[grep("negative", fData(eset)$CodeClass, ignore.case = TRUE),],
        housekeepingControl = exprs(eset)[
          grep("housekeeping", fData(eset)$CodeClass, ignore.case = TRUE),],
        designs = designs)
    
    fData(nsSet) <- fData(eset)[grep("endogenous", fData(eset)$CodeClass, ignore.case = TRUE),]
    rownames(nsSet) <- fData(nsSet)$Name
    
    return(nsSet)
}