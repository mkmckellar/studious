
## create homework html template ----


# this code was adapted from meghan hall's blog post
create_homework_html <- function(file_name = NULL, your_name = NULL) {

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

