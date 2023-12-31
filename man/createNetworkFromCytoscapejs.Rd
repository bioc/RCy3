% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Networks.R
\name{createNetworkFromCytoscapejs}
\alias{createNetworkFromCytoscapejs}
\title{Create a Network from Cytoscapejs}
\usage{
createNetworkFromCytoscapejs(
  cytoscapejs,
  title = NULL,
  collection = "My CytoscapeJS Network Collection",
  base.url = .defaultBaseUrl
)
}
\arguments{
\item{cytoscapejs}{network (nodes, edges, attributes, node positions and metadata) in CytoscapeJS format}

\item{title}{network name (NULL means use the name in cytoscapejs)}

\item{collection}{collection name (NULL means create an unnamed collection)}

\item{base.url}{(optional) Ignore unless you need to specify a custom domain,
port or version to connect to the CyREST API. Default is http://localhost:1234
and the latest version of the CyREST API supported by this version of RCy3.}
}
\value{
The SUID of the new network
}
\description{
Create a network from CytoscapeJS JSON
}
\examples{
\donttest{
createNetworkFromCytoscapejs()
}
}
