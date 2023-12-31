# ------------------------------------------------------------------------------
#' @title notebookExportShowImage
#'
#' @description Show network view in notebook output.
#' @details Show network view in notebook output.
#' @param filename (\code{character}) Full path or path relative to current 
#' working directory, in addition to the name of the file. Extension is 
#' automatically added based on the \code{type} argument. If blank, the current
#' network name will be used.
#' @param type (\code{character}) Type of image to export, e.g., PNG (default), 
#' JPEG, PDF, SVG. 
#' @param resolution (\code{numeric}) The resolution of the exported image, in DPI. Valid 
#' only for bitmap formats, when the selected width and height 'units' is inches. The 
#' possible values are: 72 (default), 100, 150, 300, 600. 
#' @param units (\code{character}) The units for the 'width' and 'height' values. Valid 
#' only for bitmap formats, such as PNG and JPEG. The possible values are: pixels (default), inches.
#' @param height (\code{numeric}) The height of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param width (\code{numeric}) The width of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param zoom (\code{numeric}) The zoom value to proportionally scale the image. The default 
#' value is 100.0. Valid only for bitmap formats, such as PNG and JPEG
#' @param sandboxName Name of sandbox containing file. None means "the current sandbox".
#' @param network (optional) Name or SUID of a network or view. Default is the 
#' "current" network active in Cytoscape. The first (presummably only) view 
#' associated a network is used if a specific view SUID is not provided.
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @param overwriteFile (optional) FALSE allows Cytoscape show a message box before overwriting the file if the file already
#' exists; TRUE allows Cytoscape to overwrite it without asking. Default value is TRUE.
#' @return display image
#' @examples \donttest{
#' notebookExportShowImage()
#' }
#' @export
notebookExportShowImage <- function (filename='image', type="PNG", resolution=NULL, units=NULL, height=NULL, 
                               width=NULL, zoom=NULL, sandboxName=NULL, network=NULL, base.url=.defaultBaseUrl, overwriteFile=TRUE) {
  .exportShowImage(exportFirst=TRUE, filename=filename, type=type, resolution=resolution, units=units, height=height, 
                   width=width, zoom=zoom, sandboxName=sandboxName, network=network, base.url=base.url, overwriteFile=overwriteFile)
}

# ------------------------------------------------------------------------------
#' @title notebookShowImage
#'
#' @description Show network view in notebook output.
#' @details Show network view in notebook output.
#' @param filename (\code{character}) Full path or path relative to current 
#' working directory, in addition to the name of the file. Extension is 
#' automatically added based on the \code{type} argument. If blank, the current
#' network name will be used.
#' @param type (\code{character}) Type of image to export, e.g., PNG (default), 
#' JPEG, PDF, SVG. 
#' @param resolution (\code{numeric}) The resolution of the exported image, in DPI. Valid 
#' only for bitmap formats, when the selected width and height 'units' is inches. The 
#' possible values are: 72 (default), 100, 150, 300, 600. 
#' @param units (\code{character}) The units for the 'width' and 'height' values. Valid 
#' only for bitmap formats, such as PNG and JPEG. The possible values are: pixels (default), inches.
#' @param height (\code{numeric}) The height of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param width (\code{numeric}) The width of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param zoom (\code{numeric}) The zoom value to proportionally scale the image. The default 
#' value is 100.0. Valid only for bitmap formats, such as PNG and JPEG
#' @param sandboxName Name of sandbox containing file. None means "the current sandbox".
#' @param network (optional) Name or SUID of a network or view. Default is the 
#' "current" network active in Cytoscape. The first (presummably only) view 
#' associated a network is used if a specific view SUID is not provided.
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @param overwriteFile (optional) FALSE allows Cytoscape show a message box before overwriting the file if the file already
#' exists; TRUE allows Cytoscape to overwrite it without asking. Default value is TRUE.
#' @return display image
#' @examples \donttest{
#' notebookShowImage()
#' }
#' @export
notebookShowImage <- function (filename='image', type="PNG", resolution=NULL, units=NULL, height=NULL, 
                                     width=NULL, zoom=NULL, sandboxName=NULL, network=NULL, base.url=.defaultBaseUrl, overwriteFile=TRUE) {
  .exportShowImage(exportFirst=FALSE, filename=filename, type=type, resolution=resolution, units=units, height=height, 
                   width=width, zoom=zoom, sandboxName=sandboxName, network=network, base.url=base.url, overwriteFile=overwriteFile)
}

# ------------------------------------------------------------------------------
# Internal function for notebookExportShowImage and notebookShowImage in Notebook.R
#' @title .exportShowImage
#'
#' @description Show network view in notebook output.
#' @details Show network view in notebook output.
#' @param exportFirst FALSE for notebookShowImage, TRUE for notebookExportShowImage.
#' @param filename (\code{character}) Full path or path relative to current 
#' working directory, in addition to the name of the file. Extension is 
#' automatically added based on the \code{type} argument. If blank, the current
#' network name will be used.
#' @param type (\code{character}) Type of image to export, e.g., PNG (default), 
#' JPEG, PDF, SVG. 
#' @param resolution (\code{numeric}) The resolution of the exported image, in DPI. Valid 
#' only for bitmap formats, when the selected width and height 'units' is inches. The 
#' possible values are: 72 (default), 100, 150, 300, 600. 
#' @param units (\code{character}) The units for the 'width' and 'height' values. Valid 
#' only for bitmap formats, such as PNG and JPEG. The possible values are: pixels (default), inches.
#' @param height (\code{numeric}) The height of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param width (\code{numeric}) The width of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param zoom (\code{numeric}) The zoom value to proportionally scale the image. The default 
#' value is 100.0. Valid only for bitmap formats, such as PNG and JPEG
#' @param sandboxName Name of sandbox containing file. None means "the current sandbox".
#' @param network (optional) Name or SUID of a network or view. Default is the 
#' "current" network active in Cytoscape. The first (presummably only) view 
#' associated a network is used if a specific view SUID is not provided.
#' @param base.url (optional) Ignore unless you need to specify a custom domain,
#' port or version to connect to the CyREST API. Default is http://localhost:1234
#' and the latest version of the CyREST API supported by this version of RCy3.
#' @param overwriteFile (optional) FALSE allows Cytoscape show a message box before overwriting the file if the file already
#' exists; TRUE allows Cytoscape to overwrite it without asking. Default value is TRUE.
#' @return display image
#' @examples \donttest{
#' .exportShowImage()
#' }
#' @importFrom IRdisplay display_png
#' @importFrom IRdisplay display_jpeg
#' @importFrom IRdisplay display_pdf
#' @importFrom IRdisplay display_svg
.exportShowImage <- function (exportFirst, filename='image', type="PNG", resolution=NULL, units=NULL, height=NULL, 
                               width=NULL, zoom=NULL, sandboxName=NULL, network=NULL, base.url=.defaultBaseUrl, overwriteFile=TRUE) {
  checkNotebookIsRunning()
  checkRunningRemote(base.url)
  if (getNotebookIsRunning()){
    if (length(grep(paste(".",tolower(type),"$", sep=""), filename)) != 1){
      filename = paste(filename, tolower(type), sep = ".") 
    }
    if (exportFirst){
      exportImage(filename=filename, type=type, resolution=resolution, units=units, height=height, 
                  width=width, zoom=zoom, network=network, base.url=base.url, overwriteFile=overwriteFile)
    }
    sandboxGetFrom(filename, overwrite=overwriteFile, sandboxName=sandboxName, base.url=base.url)
    if (type == "PNG"){
      display_png(file=filename)
    } else if (type == "JPEG"){
      display_jpeg(file=filename)
    } else if (type == "SVG"){
      display_svg(file=filename)
    } else {
      stop("Valid only for PNG, JPEG, SVG.")
    }
  } else {
    stop("Cannot display network view image unless running as a Jupyter Notebook.")
  }
}
