#' Create a homework report as an HTML document
#'
#' Creates a Quarto homework template in the current working directory
#' and opens it for editing. The template includes the student's name
#' in the document header.
#'
#' @param file_name A character string specifying the name of the homework
#'   file to create, without the .qmd extension. Use only letters, numbers,
#'   underscores, and hyphens. Spaces will be automatically converted to
#'   underscores.
#' @param your_name A character string with the student's name to appear
#'   in the document header. Defaults to "Your Name" if not provided.
#'
#' @param spirit An optional character string specifying the school spirit theme
#'   which will alter the style of the homework template. Currently
#'   supports \code{"pioneers"} (CSU East Bay) and \code{"aggies"} (UC Davis).
#'   Defaults to NULL for the neutral theme.
#'
#' @return Called for its side effects. Creates a .qmd file in the current
#'   working directory and opens it in RStudio if available.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Create a homework file with your name
#' create_homework_html(file_name = "homework_1", your_name = "Statistics Student")
#'
#' # Create a homework file without specifying a name
#' create_homework_html(file_name = "homework_1")
#' }

## create homework html template ----


# this code was adapted from meghan hall's blog post
create_homework_html <- function(file_name = NULL,
                                 your_name = NULL,
                                 spirit = NULL) {

  # check for your_name value
  if(is.null(your_name)) {
    your_name <- "Your Name"
  }

  # first check if file_name exists, ask user to name file if not
  if (is.null(file_name)) {
    stop("You must provide a valid file_name")
  }

  # if file_contains spaces, replace spaces with underscores silently
  # do this first before checking for invalid characters
  file_name <- gsub(" ", "_", file_name)

  # if file_name contains invalid characters, warn user
  if(grepl("[^a-zA-Z0-9_\\-]", file_name)) {
    stop("file_name contains invalid characters. Use only letters, numbers, underscores, and hyphens.")
  }

  # stop if file with same name in directory already exists
  if(file.exists(paste0(file_name, ".qmd"))) {
    stop("A file named '", file_name, ".qmd' already exists in this directory. ",
         "Please choose a different file_name.")
  }

  # define supported spirit themes
  supported_spirits <- c("aggies", "pioneers")

  # validate spirit argument if provided
  if(!is.null(spirit) && !spirit %in% supported_spirits) {
    stop("spirit must be one of: ",
         paste(supported_spirits, collapse = ", "),
         ". Or NULL for the default theme")
  }

  # resolve theme files
  if(is.null(spirit)) {
    theme_file <- "theme.scss"
  } else {
    theme_file <- paste0("theme-", spirit, ".scss")
  }

  # check for existing _extensions directory
  if(!file.exists("_extensions")) {
    dir.create("_extensions")
    message("Created '_extensions' folder")
  }

  # create folder
  if(!file.exists("_extensions/hw-html")) {
    dir.create("_extensions/hw-html")
  }

  # copy from internals, packaged referenced is this package -- studious!
  file.copy(
    from = system.file("extdata/_extensions/hw-html", package = "studious"),
    to = paste0("_extensions/"),
    overwrite = TRUE,
    recursive = TRUE,
    copy.mode = TRUE
  )

  # logic check to make sure extension files were moved
  n_files <- length(dir("_extensions/hw-html"))

  if(n_files >= 2){
    message("hw-html was installed to _extensions folder in current working directory.")
  } else {
    message("Extension appears not to have been created")
  }

  # create new qmd hw template based on source template
  template <- readLines("_extensions/hw-html/hw-html-template.qmd")

  # inject the student's name
  template <- gsub("YOUR_NAME_HERE", your_name, template)

  # inject spirit theme
  template <- gsub("THEME_FILE_HERE", theme_file, template)

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
    message("Your homework template has been created: ", paste0(file_name, ".qmd"))
  }

}

