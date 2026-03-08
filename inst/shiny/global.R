
library(shiny)
library(shinyjs)
library(omopgenerics)
library(reactable)
library(dplyr)
library(OmopCheckout)
library(shinycssloaders)
library(commonmark)
library(bslib)
library(rlang)

options(shiny.maxRequestSize = 10 * 1024^3)
# source functions
source(file.path(getwd(), "functions.R"))
