#' Deconstruct canonical names
#'
#' Deconstruct canonical names into Genus, Species and Subspecies fields
#'
#' @param dat data frame containing taxonomic list
#' @param canonical field name for canonical names
#' @param genus field name for Genus
#' @param species field name for Species
#' @param subspecies field name for Subspecies
#' @param verbose verbose output, Default: FALSE
#' @family Name functions
#' @importFrom stringr str_count
#' @return a data frame containing Genus, Species and Subspecies fields
#'  added or repopulated using data in canonical name field. If unable to parse
#'  the name Genus, Species and Subspecies fields will have NA.
#' @examples
#' \donttest{
#'mylist <- data.frame("canonical" = c("Abrothrix longipilis",
#'                                     "Acodon hirtus",
#'                                     "Akodon longipilis apta",
#'                                     "AKODON LONGIPILIS CASTANEUS",
#'                                     "Chroeomys jelskii",
#'                                     "Acodon jelskii pyrrhotis"),
#'                     stringsAsFactors = FALSE)
#' melt_canonical(mylist,"canonical","genus","species","subspecies")
#' }
#' @export
melt_canonical <- function(dat,canonical="",genus="",species="",
                           subspecies="",verbose=FALSE){
  newdat <- as.data.frame(dat)
  if(genus==""){
    return(NULL)
  } else {
    newdat <- rename_column(newdat,genus,"genus",silent=TRUE)
    newdat$genus <- NA
  }
  if(species==""){
    return(NULL)
  } else {
    newdat <- rename_column(newdat,species,"species",silent=TRUE)
    newdat$species <- NA
  }
  if(subspecies!=""){
    newdat <- rename_column(newdat,subspecies,"subspecies",silent=TRUE)
    newdat$subspecies <- NA
  }
  if(canonical!=""){
    newdat <- rename_column(newdat,canonical,"canonical")
  }
  if(verbose){pb = txtProgressBar(min = 0, max = nrow(newdat), initial = 0)}
  for(i in 1:nrow(newdat)){
    if(!is.empty(newdat$canonical[i])){
      pname <- newdat$canonical[i]
      if(length(unlist(gregexpr("[A-Z]", pname)))>1){
        warning(paste("Malformed canonical",pname))
        if(str_count(pname,'\\w+')>1){ 
          if(isproper(strsplit(pname," ")[[1]][2])){
            remstr <- paste(strsplit(pname," ")[[1]][2]," ",sep="")
            warning(paste("Asuming a subgenus in",pname))
            pname <- gsub(remstr,"",pname)
          }
        }
      }
      tl <- guess_taxo_rank(pname)
      newdat$genus[i] <- toproper(strsplit(pname," ")[[1]][1])
      if(tl=="Species" | tl=="Subspecies"){
        newdat$species[i] <- tolower(strsplit(pname," ")[[1]][2])
      }
      if(tl=="Subspecies" & subspecies!=""){
        newdat$subspecies[i] <- tolower(strsplit(pname," ")[[1]][3])
      }
      if(tl=="Unknown"){
        newdat$genus[i] <- NA
      }
    }
    if(verbose){setTxtProgressBar(pb,i)}
  }
  if(verbose){cat("\n")}
  newdat <- rename_column(newdat,"genus",genus)
  newdat <- rename_column(newdat,"species",species)
  if(subspecies!=""){
    newdat <- rename_column(newdat,"subspecies",subspecies)
  }
  newdat <- rename_column(newdat,"canonical",canonical)
  return(newdat)
}
