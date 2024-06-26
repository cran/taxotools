% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_accepted_names.R
\name{get_accepted_names}
\alias{get_accepted_names}
\title{get_accepted_names}
\usage{
get_accepted_names(
  namelist,
  master,
  gen_syn = NA,
  namelookup = NA,
  mastersource = NA,
  match_higher = FALSE,
  fuzzymatch = TRUE,
  fuzzydist = 2,
  canonical = NA,
  genus = NA,
  species = NA,
  subspecies = NA,
  prefix = "",
  verbose = TRUE
)
}
\arguments{
\item{namelist}{data frame of the list of names to be resolved. Must
contain either column canonical containing binomial or trinomial name
without spp. and var. etc. or may contain columns for genus, species
and subspecies (any sub-specific unit) and the names of the columns are
passed as subsequent parameters.}

\item{master}{data frame with required columns id, canonical and accid.
Other columns like order, family are optional. Column id is typically
running ids for each record and accid will contain 0 if the name is
currently accepted name and id number of accepted name in case the name
is a synonym. Column canonical contains binomial or trinomial without
spp. var. etc.}

\item{gen_syn}{data frame with columns Original_Genus and Valid_Genus
where Original_genus is synonym and valid_genus is one present in the
master. Default: NA when gen_syn is not used.}

\item{namelookup}{Lookup data frame for names where some names might
need manual lookup. The columns required are binomial and validname
where binomial is new name and validname is present in the master.
 Default: NA when namelookup is not used.}

\item{mastersource}{vector of sources to be used for assignment with
priority}

\item{match_higher}{match genus and family names present in canonical
field}

\item{fuzzymatch}{attempt fuzzy matching or not. Default: TRUE}

\item{fuzzydist}{fuzzy distance while matching. Default : 2}

\item{canonical}{column containing names to be resolved to accepted names
, Default: NA when columns for genus and species are specified.}

\item{genus}{column containing genus names to be resolved to accepted
names and typically accompanied by species and subspecies columns, Default: NA
when canonical parameter is supplied.}

\item{species}{column containing species names to be resolved to accepted
names and is accompanied by genus, Default: NA}

\item{subspecies}{column containing species names to be resolved to accepted
names and is accompanied by genus and species, Default: NA}

\item{prefix}{to be added to all the return fields}

\item{verbose}{display process messages, Default: TRUE}
}
\value{
data frame containing all the original columns with following
additional columns:\describe{
\item{accepted_name - }{Accepted name present in the master. NA is not resolved}
\item{method - }{method used to resolve the name. See details for explanation
of each method}
}
}
\description{
Match namelist with master and fetch the accepted names
using the linkages provided within the data
}
\details{
Name resolution methods:\describe{
\item{direct - }{was a direct match with name or a synonym}
\item{direct2 - }{was a direct match with name or a synonym in non mastersource}
\item{fuzzy - }{used fuzzy matching}
\item{gensyn - }{genus substitution with known genus level synonyms}
\item{lookup - }{Manual lookup in earlier processing}
\item{sppdrop - }{subspecies was dropped}
\item{sub2sp - }{subspecies elevated to species}
\item{genus - }{genus was matched}
\item{family - }{family was matched}
\item{NA - }{could not be resolved}
}
Note: Make sure all the data frames have same character encoding to prevent
 errors.
}
\examples{
\donttest{
master <- data.frame("id" = c(1,2,3,4,5,6,7),
                    "canonical" = c("Hypochlorosis ancharia",
                                    "Hypochlorosis tenebrosa",
                                    "Pseudonotis humboldti",
                                    "Myrina ancharia",
                                    "Hypochlorosis ancharia tenebrosa",
                                    "Hypochlorosis ancharia obiana",
                                    "Hypochlorosis lorquinii"),
                     "family" = c("Lycaenidae", "Lycaenidae", "Lycaenidae",
                                  "Lycaenidae", "Lycaenidae", "Lycaenidae",
                                  "Lycaenidae"),
                    "accid" = c(0,1,1,1,0,0,0),
                    "source" = c("itis","itis","wiki","wiki","itis",
                                 "itis","itis"),
                    stringsAsFactors = FALSE)

mylist <- data.frame("id"= c(11,12,13,14,15,16,17,18,19),
                    "scname" = c("Hypochlorosis ancharia",
                                 "Hypochlorosis ancharii",
                                 "Hypochlorosis tenebrosa",
                                 "Pseudonotis humboldtii",
                                 "Abrothrix longipilis",
                                 "Myrinana anchariana",
                                 "Hypochlorosis ancharia ancharia",
                                 "Myrina lorquinii",
                                 "Sithon lorquinii"),
                    stringsAsFactors = FALSE)

res <- get_accepted_names(namelist = mylist,
                         master=master,
                         canonical = "scname")

gen_syn_list <- data.frame("Original_Genus"=c("Pseudonotis",
                                             "Myrina"),
                          "Valid_Genus"=c("Hypochlorosis",
                                          "Hypochlorosis"),
                          stringsAsFactors = FALSE)

res <- get_accepted_names(namelist = mylist,
                         master=master,
                         gen_syn = gen_syn_list,
                         canonical = "scname")

lookup_list <- data.frame("binomial"=c("Sithon lorquinii",
                                      "Hypochlorosis humboldti"),
                         "validname"=c("Hypochlorosis lorquinii",
                                       "Hypochlorosis lorquinii"),
                         stringsAsFactors = FALSE)

res <- get_accepted_names(namelist = mylist,
                         master=master,
                         gen_syn = gen_syn_list,
                         namelookup = lookup_list,
                         canonical = "scname")

mylist_s <- melt_canonical(mylist,canonical = "scname",
                          genus = "genus",
                          species = "species",
                          subspecies = "subspecies")

res <- get_accepted_names(namelist = mylist_s,
                         master=master,
                         gen_syn = gen_syn_list,
                         namelookup = lookup_list,
                         genus = "genus",
                         species = "species",
                         subspecies = "subspecies")

res <- get_accepted_names(namelist = mylist_s,
                         master=master,
                         gen_syn = gen_syn_list,
                         namelookup = lookup_list,
                         mastersource = c("itis"),
                         genus = "genus",
                         species = "species",
                         subspecies = "subspecies")

mylist <- data.frame("id"= c(11,12,13,14,15,16,17,18),
                    "scname" = c("Hypochlorosis ancharia",
                                 "Hypochlorosis ancharii",
                                 "Hypochlorosis",
                                 "Pseudonotis",
                                 "Lycaenidae",
                                 "Pseudonotis humboldtii",
                                 "Abrothrix longipilis",
                                 "Myrinana anchariana"),
                    stringsAsFactors = FALSE)

res <- get_accepted_names(namelist = mylist,
                         master=master,
                         match_higher = TRUE,
                         canonical = "scname")
}
}
\seealso{
Other Name functions: 
\code{\link{build_gen_syn}()},
\code{\link{cast_canonical}()},
\code{\link{cast_scientificname}()},
\code{\link{check_scientific}()},
\code{\link{expand_name}()},
\code{\link{guess_taxo_rank}()},
\code{\link{list_higher_taxo}()},
\code{\link{melt_canonical}()},
\code{\link{melt_scientificname}()},
\code{\link{resolve_names}()},
\code{\link{taxo_fuzzy_match}()}
}
\concept{Name functions}
