
<!-- README.md is generated from README.Rmd. Please edit that file -->

# studious

<!-- badges: start -->
<!-- badges: end -->

This package is an active work in progress. The goal of studious is to
be a simple tool that helps students that are new to R as it was born
out of my reflections on my own learning journey as a masters student in
statistics. This package will contain code that to generate basic study
guides, homework templates, and presentation templates using Quarto
documents.

## Installation

You can install the development version of studious from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mkmckellar/studious")
```

## Example

This is a basic example on how you generate a study guide as an HTML
document.

``` r
library(studious)
## basic example to make a homework template
create_homework_html(file_name = "class101_homework1",
                     your_name = "Riley Pupil")

# example on how to make a study guide template
create_study_guide(guide = "discrete",
                   file_name = "my study guide")
```
