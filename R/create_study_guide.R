#' Create a study guide as an HTML document
#'
#' Creates a Quarto study guide template in the current working directory
#' and opens it for editing.
#'
#' @param guide A character string specifying which guide to create,
#'   without the .qmd extension. Currently supports \code{"discrete} and
#'   \code{"continious"}.
#'
#' @param file_name A character string for file name. If null, defaults to
#'   being named after the guide specified.
#'
#' @return Called for its side effects. Creates a .qmd file in the current
#'   working directory and opens it in RStudio if available.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Create a study guide
#' create_homework_html(guide = "discrete", file_name = "my_study_guide")
#'
#' # Create a homework file without specifying a file name
#' create_homework_html(guide = "discrete")
#' }

# create a study guide as an html document

create_study_guide <- function(guide = NULL,
                               file_name = NULL) {

  ### first make sure if study guide is supported ----
  # list of supported html guides
  supported_guides <- c("discrete", "continuous")

  # validate guide argument
  if(is.null(guide) && !guide %in% supported_guides) {
    stop("guide must be one of: ",
         paste(supported_guides, collapse = ", "))
  }

  ### make sure file name is acceptable ----
  # set file name
  if(is.null(file_name)) {
    file_name <- paste0(guide, "_study_guide")
  } else {
    # if file_name  spaces, replace spaces with underscores silently
    file_name <- gsub(" ", "_", file_name)
    # and check if file name has invalid characters
    # if file_name contains invalid characters then warn user
    if(grepl("[^a-zA-Z0-9_\\-]", file_name)) {
      stop("file_name contains invalid characters. Use only letters, numbers, underscores, and hyphens.")
    }
  }

  # stop if file with same name in directory already exists
  if(file.exists(paste0(file_name, ".qmd"))) {
    stop("A study guide named '", file_name, ".qmd' already exists in this directory. ",
         "Please choose a different file_name.")
  }

  ### create study guide from extensions ----
  # check for existing _extensions directory
  if(!file.exists("_extensions")) {
    dir.create("_extensions")
    message("Created '_extensions' folder")
  }

  # create folder
  # NOTE -- DOUBLE CHECK IF THIS IS NECESSARY
  if(!file.exists(paste0("_extensions/guide-html"))) {
    dir.create(paste0("_extensions/guide-html"))
  }

  # copy from internals, packaged referenced is this package -- studious!
  file.copy(
    from = system.file(paste0("extdata/_extensions/guide-html"),
                       package = "studious"),
    to = paste0("_extensions/"),
    overwrite = TRUE,
    recursive = TRUE,
    copy.mode = TRUE
  )

  # logic check to make sure extension files were moved
  n_files <- length(dir("_extensions/guide-html"))

  if(n_files >= 2){
    message("guide-html was installed to _extensions folder in current working directory.")
  } else {
    message("Extension appears not to have been created")
  }

  # create new qmd hw template based on source template
  template <- readLines(paste0("_extensions/guide-html/", guide, ".qmd"))

  # write the modified version to the new file_name.qmd
  writeLines(template, paste0(file_name, ".qmd"))

  # After creating the .qmd file open new file in editor like RStudio
  # or tell them it was created.
  if(interactive() && rstudioapi::isAvailable()) {
    # User is in RStudio interactively -- open the file for them
    invisible(rstudioapi::navigateToFile(paste0(file_name, ".qmd")))
  } else {
    # User is in a plain R terminal, or rendering a document
    # Just tell them where the file is instead
    message("Your study guide template has been created: ", paste0(file_name, ".qmd"))
  }

}
