% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/NetworkSelection.R
\name{selectAll}
\alias{selectAll}
\title{Select all nodes and edges}
\usage{
selectAll(network = NULL, base.url = .defaultBaseUrl)
}
\arguments{
\item{network}{(optional) Name or SUID of the network into which you want to select; 
default is "current" network}

\item{base.url}{(optional) Ignore unless you need to specify a custom domain,
port or version to connect to the CyREST API. Default is http://localhost:1234
and the latest version of the CyREST API supported by this version of RCy3.}
}
\value{
Selects all nodes and edges in a specified network.
}
\description{
Selects all nodes and edges in a Cytoscape Network
}
\examples{
\donttest{
selectAllNodes()
}
}
\seealso{
\code{\link{selectNodes}}
}
\author{
Alexander Pico, Julia Gustavsen
}
