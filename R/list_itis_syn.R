#' Get ITIS Synonyms for list of names
#'
#' Fetch Synonyms from ITIS
#'
#' @param namelist list of scientific names
#' @family ITIS functions
#' @return a data frame containing names (passed) and synonyms
#' @examples
#' \dontrun{
#' list_itis_syn("Abrothrix longipilis")
#' #list_itis_syn(c("Abditomys latidens", "Abeomelomys sevia", "Abrothrix jelskii" ))
#' }
#' @export
list_itis_syn <- function(namelist){
  retset <- NULL
  for (i in 1:length(namelist)){
    set1 <- get_itis_syn(namelist[i])
    if(!is.null(set1)){
      set1 <- cbind(namelist[i],set1)
      retset <- rbind(retset,set1)
    }
  }
  retset <- as.data.frame(retset)
  names(retset) <- c("Name","Syn")
  return(retset)
}
