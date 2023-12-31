% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Layouts.R
\name{scaleLayout}
\alias{scaleLayout}
\title{Scale Layout}
\usage{
scaleLayout(
  axis,
  scaleFactor,
  selected.only = FALSE,
  network = NULL,
  base.url = .defaultBaseUrl
)
}
\arguments{
\item{axis}{The axis to scale. Options: "X Axis", "Y Axis", "Both Axes".}

\item{scaleFactor}{The axis The scale factor to apply to the network.}

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
Scale the layout in either the X, Y, or both directions.
}
\examples{
\donttest{
scaleLayout('X Axis', 2, 'current', selected.only=FALSE)
}
}
\author{
Yihang Xin
}
