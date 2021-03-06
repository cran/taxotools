#' @title Darwin Core to Taxolist format
#' @description Converts a Darwin Core name list to taxolist format
#' @param namelist names list in Darwin Core format
#' @param statuslist vector listing taxonomicStatus to be considered in
#' the namelist. If Default value is NA, automatically uses list of
#' \itemize{\item{Accepted}\item{Synonym}\item{Valid}
#' \item{heterotypicSynonym}#' \item{homotypicSynonym}}
#' @param source source of the namelist. Default NA
#' @return names list is taxolist format
#' @details The name lists downloaded for ITIS website in Darwin Core format has
#' all the required fields. Just needs to be converted and quality checked in terms
#'  of missing linkages
#' @family list functions
#' @importFrom plyr rename
#' @importFrom stringr word
#' @examples
#' \dontrun{
#' if(interactive()){
#'  taxolist <- DwC2taxo(namelist)
#'  }
#' }
#' @rdname DwC2taxo
#' @export
DwC2taxo <- function(namelist,
                     statuslist=NA,
                     source=NA){
  if(is.na(statuslist)){
    statuslist <- c("Accepted","Synonym", "Valid",
                    "heterotypicSynonym","homotypicSynonym")
  }
  statuslist <- toupper(statuslist)
  if("taxonRank" %in% names((namelist))){
    namelist <- namelist[which(toupper(namelist$taxonRank) == "SPECIES" |
                                 toupper(namelist$taxonRank) == "SUBSPECIES"),]
  } else {
    warning("taxonRank not found.")
    return(NULL)
  }
  if("taxonomicStatus" %in% names((namelist))){
    namelist <- namelist[which(toupper(namelist$taxonomicStatus) %in%
                                 statuslist),]
  }
  if("taxonID" %in% names((namelist))){
    namelist <- rename(namelist,
                       replace = c("taxonID" = "id",
                                   "acceptedNameUsageID" = "accid",
                                   "specificEpithet" = "species",
                                   "infraspecificEpithet" = "subspecies",
                                   "taxonRank" = "taxonlevel"))
    namelist <- cast_canonical(namelist,
                               "canonical",
                               "genus",
                               "species",
                               "subspecies")
    namelist$accid[is.na(namelist$accid)] <- 0
    namelist1 <- namelist[which(namelist$accid!=0 & namelist$accid %!in%
                                  namelist$id),c("id", "order",
                                                 "family", "genus",
                                                 "species",
                                                 "subspecies",
                                                 "taxonlevel", "accid",
                                                 "canonical")]

    namelist <- namelist[which(namelist$accid==0 | namelist$accid %in%
                                 namelist$id),c("id", "order",
                                                "family", "genus",
                                                "species",
                                                "subspecies",
                                                "taxonlevel", "accid",
                                                "canonical")]
    names(namelist) <- c("id", "order", "family", "genus", "species",
                         "subspecies", "taxonlevel", "accid", "canonical")

  }
  if("taxonKey" %in% names((namelist))){
    namelist <- rename(namelist,
                       replace = c("taxonKey" = "id",
                                   "acceptedTaxonKey" = "accid",
                                   "taxonRank" = "taxonlevel"))
    namelist <- melt_scientificname(namelist,
                                    sciname = "acceptedScientificName",
                                    genus = "genus_a",
                                    species = "species_a",
                                    subspecies = "subspecies_a")
    namelist <- cast_canonical(namelist,
                               "accepted",
                               "genus_a",
                               "species_a",
                               "subspecies_a")
    namelist1 <- namelist[,c("accid", "order",
                             "family", "genus_a",
                             "species_a",
                             "subspecies_a",
                             "taxonlevel", "id",
                             "accepted")]
    names(namelist1) <- c("id", "order", "family", "genus", "species",
                          "subspecies", "taxonlevel", "accid", "canonical")
    namelist1$accid <- 0
    namelist1 <- namelist1[!duplicated(namelist1$id),]
    namelist$accid[which(namelist$accid==namelist$id)] <- 0
    namelist2 <- namelist[which(namelist$accid!=0 &
                                  !is.na(namelist$speciesKey)),]
    namelist2 <- melt_scientificname(namelist2,
                                     sciname = "scientificName",
                                     genus = "genus_s",
                                     species = "species_s",
                                     subspecies = "subspecies_s")
    namelist2 <- cast_canonical(namelist2,"synonym","genus_s",
                                "species_s", "subspecies_s")
    namelist2 <- namelist2[which(namelist2$accid %in%
                                   namelist1$id),c("id", "order",
                                                   "family", "genus_s",
                                                   "species_s",
                                                   "subspecies_s",
                                                   "taxonlevel", "accid",
                                                   "synonym")]
    names(namelist2) <- c("id", "order", "family", "genus", "species",
                          "subspecies", "taxonlevel", "accid", "canonical")
    namelist <- rbind(namelist1,namelist2)
  }
  namelist$source <- source
  return(namelist)
}
