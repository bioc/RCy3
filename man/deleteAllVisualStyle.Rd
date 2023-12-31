% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Styles.R
\name{deleteAllVisualStyle}
\alias{deleteAllVisualStyle}
\title{Delete All Visual Style}
\usage{
deleteAllVisualStyle(base.url = .defaultBaseUrl)
}
\arguments{
\item{base.url}{(optional) Ignore unless you need to specify a custom domain,
port or version to connect to the CyREST API. Default is http://localhost:1234
and the latest version of the CyREST API supported by this version of RCy3.}
}
\value{
None
}
\description{
Delete all visual styles from current Cytoscape session
}
\examples{
\donttest{
deleteAllVisualStyle()
}
}
