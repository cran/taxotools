% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/melt_canonical.R
\name{melt_canonical}
\alias{melt_canonical}
\title{Deconstruct canonical names}
\usage{
melt_canonical(
  dat,
  canonical = "",
  genus = "",
  species = "",
  subspecies = "",
  verbose = FALSE
)
}
\arguments{
\item{dat}{data frame containing taxonomic list}

\item{canonical}{field name for canonical names}

\item{genus}{field name for Genus}

\item{species}{field name for Species}

\item{subspecies}{field name for Subspecies}

\item{verbose}{verbose output, Default: FALSE}
}
\value{
a data frame containing Genus, Species and Subspecies fields
 added or repopulated using data in canonical name field. If unable to parse
 the name Genus, Species and Subspecies fields will have NA.
}
\description{
Deconstruct canonical names into Genus, Species and Subspecies fields
}
\examples{
\donttest{
mylist <- data.frame("canonical" = c("Abrothrix longipilis",
                                    "Acodon hirtus",
                                    "Akodon longipilis apta",
                                    "AKODON LONGIPILIS CASTANEUS",
                                    "Chroeomys jelskii",
                                    "Acodon jelskii pyrrhotis"),
                    stringsAsFactors = FALSE)
melt_canonical(mylist,"canonical","genus","species","subspecies")
}
}
\seealso{
Other Name functions: 
\code{\link{build_gen_syn}()},
\code{\link{cast_canonical}()},
\code{\link{cast_scientificname}()},
\code{\link{check_scientific}()},
\code{\link{expand_name}()},
\code{\link{get_accepted_names}()},
\code{\link{guess_taxo_rank}()},
\code{\link{list_higher_taxo}()},
\code{\link{melt_scientificname}()},
\code{\link{resolve_names}()},
\code{\link{taxo_fuzzy_match}()}
}
\concept{Name functions}
