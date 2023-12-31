# ------------------------------------------------------------------------------
# Create a unique channel that identifies this process so other processes don't mix up messages
#' @import uuid
CHANNEL <- UUIDgenerate()
JupyterBRIDGEURL <- 'https://jupyter-bridge.cytoscape.org'
runningRemote <<- NULL # NULL means "Don't know whether Cytoscape is local or remote yet"
notebookIsRunning <<- NULL

# ------------------------------------------------------------------------------
#' @title spoofResponse
#' @description Call CyREST as a remote service via Jupyter-bridge
#' @import RJSONIO
#' @export
spoofResponse <- setClass(
    "spoofResponse",
    slots = c(
        URL = "ANY",
        status_code = "ANY",
        Reason = "ANY",
        Text = "ANY"
    )
)

setGeneric("repr", function(object, ...) standardGeneric("repr"))
setGeneric("jsonLoads", function(object, ...) standardGeneric("jsonLoads"))
setGeneric("raiseForStatus", function(object, ...) standardGeneric("raiseForStatus"))

setMethod(f="initialize", signature="spoofResponse",
          definition=function(.Object) {
              .Object@URL <- "https://jupyter-bridge.cytoscape.org"
              .Object@status_code <- "0"
              .Object@Reason <- "reason"
              .Object@Text <- "text"
              return(.Object)
          }
)

setMethod("repr", "spoofResponse", function(object, ...) {
    dput(object@status_code)
}) 

setMethod("jsonLoads", "spoofResponse", function(object, ...) {
    spoofResponsetext <- fromJSON(object@Text)
    return(spoofResponsetext)
}) 

setMethod("raiseForStatus", "spoofResponse", function(object, ...) {
    if(object@status_code < 500 & object@status_code >= 400){
        stop("Client Error")
    }
    else if(object@status_code < 600 & object@status_code >= 500){
        stop("Server Error")
    }
}) 

# ------------------------------------------------------------------------------
#' @title getBrowserClientChannel
#'
#' @description Get the unique channel
#' @return client channel
#' @examples \donttest{
#' getBrowserClientChannel()
#' }
#' @export
getBrowserClientChannel<-function(){
    return(CHANNEL)
}

# ------------------------------------------------------------------------------
#' @title getJupyterBridgeURL
#'
#' @description Get the jupyter bridge server url
#' @return jupyter bridge server url
#' @examples \donttest{
#' getJupyterBridgeURL()
#' }
#' @export
getJupyterBridgeURL<-function(){
    return(JupyterBRIDGEURL)
}

# ------------------------------------------------------------------------------
#' @title getBrowserClientJs
#'
#' @description Prepend channel number of client Javascript so it can communicate with this process via Jupyter-bridge
#' @return Javascript inject code
#' @examples \donttest{
#' getBrowserClientJs()
#' }
#' @importFrom httr GET
#' @importFrom httr content
#' @export
getBrowserClientJs<-function(){
    r <- GET("https://raw.githubusercontent.com/cytoscape/jupyter-bridge/master/client/javascript_bridge.js")
    injectCode <- sprintf('var Channel = "%s"; \n\n var JupyterBridge = "%s"; \n\n %s',CHANNEL, JupyterBRIDGEURL, content(r, 'text') )
    return(injectCode)
}

# ------------------------------------------------------------------------------
#' @title doRequestRemote
#'
#' @description Do requests remotely by connecting over Jupyter-Bridge.
#' @param method A string to be converted to the REST query namespace
#' @param qurl A named list of values to be converted to REST query parameters
#' @param qbody A named list of values to be converted to JSON
#' @param headers httr headers
#' @return httr response
#' @examples \donttest{
#' doRequestRemote()
#' }
#' @import httr
#' @import stringi
#' @importFrom RJSONIO fromJSON toJSON isValidJSON
#' @export
doRequestRemote<-function(method, qurl, qbody=NULL, headers=NULL){
    tryCatch(
        expr = {
            request <- list(command = method, url = qurl, data = qbody, headers=headers)
            request <- toJSON(request)
            url_post <- sprintf('%s/queue_request?channel=%s',JupyterBRIDGEURL, CHANNEL)
            r <- POST(url_post, body = request, add_headers("Content-Type" = "application/json"))
        },
        error = function(e){
            message('Error posting to Jupyter-bridge!')
            print(e)
        }
    )
    tryCatch(
        expr = {
            while (TRUE){
                url_get <- sprintf('%s/dequeue_reply?channel=%s',JupyterBRIDGEURL, CHANNEL)
                r <- GET(url_get)
                if(status_code(r) != 408){break}
            }
        },
        error = function(e){
            message('Error receiving from Jupyter-bridge!')
            print(e)
        }        
    )
    tryCatch(
        expr = {
            rContent <- content(r, "text", encoding = "UTF-8")
            encoding <- stri_enc_detect(rContent)[[1]]$Encoding[1]
            message <- toString((iconv(rContent, to=encoding)))
            cyReply <- fromJSON(message)
        },
        error = function(e){
            message('Undeciperable message received from Jupyter-bridge!')
            print(e)
        }
    )
    jsonMessage = spoofResponse()
    if (cyReply[1] == 0){ 
        stop("Could not contact url")
    }
    jsonMessage@status_code <- cyReply[1]
    jsonMessage@Reason <- cyReply[2]
    jsonMessage@Text <- cyReply[3]
    return(r)
}

# ------------------------------------------------------------------------------
#' @title setNotebookIsRunning
#' @description setNotebookIsRunning
#' @param newState new state of running remote
#' @return oldState
#' @examples \donttest{
#' setNotebookIsRunning()
#' }
#' @export
setNotebookIsRunning<-function(newState=NULL){
    oldState <- .GlobalEnv$notebookIsRunning
    .GlobalEnv$notebookIsRunning <- newState
    return(oldState)
}

# ------------------------------------------------------------------------------
#' @title getNotebookIsRunning
#' @description getNotebookIsRunning
#' @return None
#' @examples \donttest{
#' getNotebookIsRunning()
#' }
#' @export
getNotebookIsRunning<-function(){
    return(.GlobalEnv$notebookIsRunning)
}

# ------------------------------------------------------------------------------
#' @title checkNotebookIsRunning
#' @description checkNotebookIsRunning
#' @return None
#' @examples \donttest{
#' checkNotebookIsRunning()
#' }
#' @import IRkernel
#' @export
checkNotebookIsRunning<-function(){
    IRkernel::jupyter_option_defaults
    if(is.null(getNotebookIsRunning())){
        if(isTRUE(getOption("jupyter.in_kernel"))){
            setNotebookIsRunning(TRUE)
        }
        else{
            setNotebookIsRunning(FALSE)
        }
    }
}

# ------------------------------------------------------------------------------
#' @title runningRmoteCheck
#' @description runningRmoteCheck
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @param newState new state of running remote
#' @return oldState
#' @examples \donttest{
#' runningRmoteCheck()
#' }
#' @export
runningRemoteCheck<-function(base.url=.defaultBaseUrl, newState=NULL){
    checkRunningRemote(base.url)
    oldState <- .GlobalEnv$runningRemote
    if(!is.null(newState)){
        .GlobalEnv$runningRemote <- newState
    }
    return(oldState)
}

# ------------------------------------------------------------------------------
#' @title checkRunningRemote
#' @description Determine whether we're running locally or on a remote server. If locally (either via raw R or via a
#' locally installed Notebook), we prefer to connect to Cytoscape over a local socket. If remote, we have to
#' connect over Jupyter-Bridge. Either way, we can determine which by whether Cytoscape answers to a version
#' check. If Cytoscape doesn't answer, we have no information ... and we have to wait until Cytoscape is
#' started and becomes reachable before we can determine local vs remote.
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @return None
#' @examples \donttest{
#' checkRunningRemote()
#' }
#' @import httr
#' @export
checkRunningRemote<-function(base.url=.defaultBaseUrl){
    tryCatch(
        expr={
    if(getNotebookIsRunning()){
        if(is.null(.GlobalEnv$runningRemote)){
            tryCatch(
                expr = {
                    r <- GET(url=base.url)
                    status_code(r)
                    .GlobalEnv$runningRemote <- FALSE
                },
                error = function(e){
                    tryCatch(
                        expr = {
                    doRequestRemote("GET", base.url)
                    .GlobalEnv$runningRemote <- TRUE},
                    error = function(e){
                        message('Error initially contacting Jupyter-bridge!')
                        print(e)
                        .GlobalEnv$runningRemote <- NULL
                    }
                    )
                }
            )
        }
    }else{
        .GlobalEnv$runningRemote <- FALSE 
    }
        },
    error = function(e){
        checkNotebookIsRunning()
        checkRunningRemote(base.url)
    })
    return(.GlobalEnv$runningRemote)
}

# ------------------------------------------------------------------------------