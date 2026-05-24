library(shiny)
library(bslib)
library(shinyjs)
library(jsonlite)
library(markdown)
library(htmltools)

source("R/render_event.R", local = TRUE)
source("R/replay_engine.R", local = TRUE)
source("R/ui.R", local = TRUE)
source("R/server.R", local = TRUE)

shinyApp(ui = app_ui(), server = app_server)
