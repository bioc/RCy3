% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Layouts.R
\name{rotateLayout}
\alias{rotateLayout}
\title{Rotate Layout}
\usage{
rotateLayout(
  angle,
  selected.only = FALSE,
  network = NULL,
  base.url = .defaultBaseUrl
)
}
\arguments{
\item{angle}{The angle (in degrees) to rotate the network. From -180 to 180}

\item{selected.only}{(Boolean) Whether to rotate only current selection. Default 
is false.}

\item{network}{(optional) Name or SUID of the network. Default is the 
"current" network active in Cytoscape.}

\item{base.url}{(optional) Ignore unless you need to specify a custom domain,
port or version to connect to the CyREST API. Default is http://localhost:1234
and the latest version of the CyREST API supported by this version of RCy3.}
}
\value{
None
}
\description{
Rotate the layout.
}
\examples{
\donttest{
rotateLayout(90, 'current', selected.only=FALSE)
}
}
\author{
Yihang Xin
}
