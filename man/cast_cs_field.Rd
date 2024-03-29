% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cast_cs_field.R
\name{cast_cs_field}
\alias{cast_cs_field}
\title{Build a character (comma) separated List within field}
\usage{
cast_cs_field(
  data,
  pri,
  sec,
  duplicate = FALSE,
  sepchar = ",",
  verbose = FALSE
)
}
\arguments{
\item{data}{data frame containing primary and secondary data columns}

\item{pri}{Primary field name (repeating values)}

\item{sec}{Secondary field (values would be added to same record,
comma separated)}

\item{duplicate}{If true, duplicate entries are allowed in secondary field}

\item{sepchar}{Character separator between the data items. Default is comma}

\item{verbose}{verbose output, Default: FALSE}
}
\value{
a data frame with two fields Primary and secondary (comma
separated list)
}
\description{
Builds a character (comma) separated list within a field given a data frame
with primary field repeating values and secondary field with values to be
character separated in the same field (secondary)
}
\examples{
\donttest{
  scnames <- c("Abrothrix longipilis", "Abrothrix jelskii")
  SynList <- list_itis_syn(scnames)
  cast_cs_field(SynList,"canonical","synonym")
}

}
\seealso{
Other List functions: 
\code{\link{DwC2taxo}()},
\code{\link{compact_ids}()},
\code{\link{get_synonyms}()},
\code{\link{match_lists}()},
\code{\link{melt_cs_field}()},
\code{\link{merge_lists}()},
\code{\link{syn2taxo}()},
\code{\link{synonymize_subspecies}()},
\code{\link{taxo2DwC}()},
\code{\link{taxo2doc}()},
\code{\link{taxo2syn}()},
\code{\link{wiki2taxo}()}
}
\concept{List functions}
