% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Styles.R
\name{exportVisualStyles}
\alias{exportVisualStyles}
\title{Export Visual Styles}
\usage{
exportVisualStyles(
  filename = NULL,
  type = "XML",
  styles = NULL,
  base.url = .defaultBaseUrl,
  overwriteFile = TRUE
)
}
\arguments{
\item{filename}{(char) Full path or path relative to current 
working directory, in addition to the name of the file. Extension is 
automatically added based on the \code{type} argument. Default is 
"styles.xml"}

\item{type}{(optional) Type of data file to export, e.g., XML, JSON (case 
sensitive). 
Default is XML. Note: Only XML can be read by importVisualStyles().}

\item{styles}{(optional) The styles to be exported, listed as a 
comma-separated string. 
If no styles are specified, only the current one is exported.}

\item{base.url}{(optional) Ignore unless you need to specify a custom domain,
port or version to connect to the CyREST API. Default is http://localhost:1234
and the latest version of the CyREST API supported by this version of RCy3.}

\item{overwriteFile}{(optional) FALSE allows Cytoscape show a message box before overwriting the file if the file already
exists; TRUE. allows Cytoscape to overwrite it without asking. Default value is TRUE.}
}
\value{
Path to saved file
}
\description{
Save one or more visual styles to file.
}
\examples{
\donttest{
exportVisualStyles('/fullpath/myStyle')
exportVisualStyles('/fullpath/myStyle', type = 'JSON')
exportVisualStyles('/fullpath/myStyle', style = 'Minimal,default,Directed')
}
}
\seealso{
importVisualStyles
}
