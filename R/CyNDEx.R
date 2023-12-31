# ==============================================================================
# Functions for communicating with NDEx from within Cytoscape.
# ------------------------------------------------------------------------------
#' @title Import Network From NDEx
#'
#' @description Import a network from the NDEx database into Cytoscape.
#' @param ndex.id Network \code{externalId} provided by NDEx. This is not the 
#' same as a Cytoscape SUID.
#' @param username (optional) NDEx account username; required for private content
#' @param password (optional) NDEx account password; required for private content
#' @param accessKey (optional) NDEx accessKey; alternate access to private content
#' @param ndex.url (optional) For alternative instances or deployments of NDEx; 
#' default is "http://ndexbio.org"
#' @param ndex.version (optional) For alternative versions of the NDEx API; 
#' default is "v2"
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @return (integer) SUID of imported network
#' @examples \donttest{
#' importNetworkFromNDEx(ndex.id)
#' }
#' @export
importNetworkFromNDEx <- function (ndex.id, username=NULL, password=NULL, 
                                   accessKey=NULL, 
                                   ndex.url="http://ndexbio.org",
                                   ndex.version="v2",
                                   base.url = .defaultBaseUrl){
    if (!grepl("^https?://", ndex.url))
        ndex.url <- paste0("http://",ndex.url)
    
    server.url <- paste(ndex.url,ndex.version, sep = "/")
    
    ndex.body <- list(serverUrl=server.url, uuid=ndex.id)
    
    if(!is.null(username))
        ndex.body[['username']] <- username
    if(!is.null(password))
        ndex.body[['password']] <- password
    if(!is.null(accessKey))
        ndex.body[['accessKey']] <- accessKey
    if(!findRemoteCytoscape(base.url)){
    res <- cyrestPOST('networks',
                       body = ndex.body,
                       base.url = .CyndexBaseUrl(base.url))
    } else {
        res <- .CyndexPOST('networks',
                           body = ndex.body,
                           base.url = .CyndexBaseUrl(base.url))
    }
    return(res$data$suid)
}

# ------------------------------------------------------------------------------
#' @title Export Network To NDEx
#'
#' @description Send a copy of a Cytoscape network to NDEx as a new submission.
#' @param username NDEx account username
#' @param password NDEx account password
#' @param isPublic (Boolean) Whether to make the network publicly 
#' accessible at NDEx. 
#' @param network (optional) Name or SUID of the network. Default is the "current" 
#' network active in Cytoscape.
#' @param metadata (optional) A list of structured information describing the network
#' @param ndex.url (optional) For alternative instances or deployments of NDEx; 
#' default is "http://ndexbio.org"
#' @param ndex.version (optional) For alternative versions of the NDEx API; 
#' default is "v2"
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @return NDEx identifier (\code{externalId}) for new submission
#' @examples \donttest{
#' exportNetworkToNDEx("user", "pass", TRUE)
#' }
#' @export
exportNetworkToNDEx <- function(username, password, isPublic, 
                                network=NULL, metadata=NULL, 
                                ndex.url="http://ndexbio.org",
                                ndex.version="v2",
                                base.url = .defaultBaseUrl){
    if (!grepl("^https?://", ndex.url))
        ndex.url <- paste0("http://",ndex.url)
    
    server.url <- paste(ndex.url,ndex.version, sep = "/")

    suid <- getNetworkSuid(network,base.url)
    if(!findRemoteCytoscape(base.url)){
    res <- cyrestPOST(paste('networks',suid,sep = '/'),
                      body = list(serverUrl=server.url,
                                  username=username,
                                  password=password,
                                  metadata=metadata,
                                  isPublic=isPublic),
                      base.url = .CyndexBaseUrl(base.url))
    } else {
        res <- .CyndexPOST(paste('networks',suid,sep = '/'),
                           body = list(serverUrl="http://ndexbio.org/v2",
                                       username=username,
                                       password=password,
                                       metadata=metadata,
                                       isPublic=isPublic),
                           base.url = .CyndexBaseUrl(base.url))
    }
    return(res$data$uuid)
}

# ------------------------------------------------------------------------------
#' @title Update Network In NDEx
#'
#' @description Update an existing network in NDEx, given a previously 
#' assoicaiated Cytoscape network, e.g., previously exported to NDEx or imported
#' from NDEx. 
#' @param username NDEx account username
#' @param password NDEx account password
#' @param isPublic (Boolean) Whether to make the network publicly 
#' accessible at NDEx.
#' @param network (optional) Name or SUID of the network. Default is the "current" 
#' network active in Cytoscape.
#' @param metadata (optional) A list of structured information describing the network
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @return NDEx identifier (\code{externalId}) for the updated submission
#' @examples \donttest{
#' updateNetworkInNDEx("user", "pass", TRUE)
#' }
#' @export
updateNetworkInNDEx <- function (username, password, isPublic, network = NULL, metadata = NULL, 
                                 base.url = .defaultBaseUrl) 
{
    suid <- getNetworkSuid(network, base.url)
    if (!findRemoteCytoscape(base.url)) {
        res <- cyrestPUT(paste("networks", suid, sep = "/"), 
                         body = list(serverUrl = "http://ndexbio.org/v2", 
                                     username = username, password = password, metadata = metadata, 
                                     isPublic = isPublic), base.url = .CyndexBaseUrl(base.url))
    }
    else {
        res <- .CyndexPUT(paste("networks", suid, sep = "/"), 
                          body = list(serverUrl = "http://ndexbio.org/v2", 
                                      username = username, password = password, metadata = metadata, 
                                      isPublic = isPublic), base.url = .CyndexBaseUrl(base.url))
    }
    return(res$data$uuid)
}

# ------------------------------------------------------------------------------
#' @title Get Network NDEx Id
#'
#' @description Retrieve the NDEx externalId for a Cytoscape network, presuming
#' it has already been exported to NDEx.
#' @details If the Cytoscape network is not associated with an NDEx network, the
#' return value will be NULL.
#' @param network (optional) Name or SUID of the network. Default is the "current" 
#' network active in Cytoscape.
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @return NDEx identifier (\code{externalId}) or NULL
#' @examples \donttest{
#' getNetworkNDExId()
#' }
#' @export
getNetworkNDExId <- function(network=NULL, base.url = .defaultBaseUrl) {
    suid <- getNetworkSuid(network,base.url)
    if (!findRemoteCytoscape(base.url)) {
    res <- cyrestGET(paste('networks', suid,sep = '/'),
                     base.url = .CyndexBaseUrl(base.url))
    return(res$data$members[[1]]$uuid)
    } else {
        conn.str <- paste(.CyndexBaseUrl(base.url), 'networks', sep = '/')
        q.url <- paste(conn.str, suid, sep = '')
        res <- doRequestRemote("GET", q.url)
        return(fromJSON(fromJSON(rawToChar(res$content))$text)$data$members[[1]]$uuid)
    }
}

# ------------------------------------------------------------------------------
# @title CyndexBaseUrl
# 
# @description Transforms generic base.url into a specific cyndex.base.url
.CyndexBaseUrl <- function(base.url)
{
    gsub('(.+?)\\/(v\\d+)$','\\1\\/cyndex2\\/\\2', base.url)
}
# ------------------------------------------------------------------------------
# @title CyndexPOST
# 
# @description Transforms generic base.url into a specific cyndex.base.url
.CyndexPOST <- function(operation, parameters=NULL, body=NULL, base.url=.defaultBaseUrl)
{
    q.url <- paste(.CyndexBaseUrl(base.url), .pathURLencode(operation), sep="/")
    if(!is.null(parameters)){
        q.params <- .prepGetQueryArgs(parameters)
        q.url <- paste(q.url, q.params, sep="?")
    }
    q.body <- body
    res <- doRequestRemote("POST", URLencode(q.url), q.body, headers=list("Content-Type" = "application/json"))
    if(length(res$content)>0){
        res.char <- rawToChar(res$content)
        if (isValidJSON(res.char, asText = TRUE)){
            return(fromJSON(fromJSON(res.char)$text))
        } else {
            return(res.char)
        }
    } else{
        invisible(res)
    }
}
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# @title CyndexPUT
# 
# @description Transforms generic base.url into a specific cyndex.base.url
.CyndexPUT <- function(operation, parameters=NULL, body=NULL, base.url=.defaultBaseUrl)
{
    q.url <- paste(.CyndexBaseUrl(base.url), .pathURLencode(operation), sep="/")
    if(!is.null(parameters)){
        q.params <- .prepGetQueryArgs(parameters)
        q.url <- paste(q.url, q.params, sep="?")
    }
    q.body <- body
    res <- doRequestRemote("PUT", URLencode(q.url), q.body, headers=list("Content-Type" = "application/json"))
    if(length(res$content)>0){
        res.char <- rawToChar(res$content)
        if (isValidJSON(res.char, asText = TRUE)){
            return(fromJSON(fromJSON(res.char)$text))
        } else {
            return(res.char)
        }
    } else{
        invisible(res)
    }
}
# ------------------------------------------------------------------------------