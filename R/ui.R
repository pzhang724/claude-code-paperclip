app_ui <- function() {
  bslib::page_fluid(
    theme = bslib::bs_theme(
      version = 5,
      bootswatch = "flatly",
      base_font = bslib::font_collection(bslib::font_google("Inter", local = FALSE), "system-ui", "sans-serif"),
      code_font = bslib::font_collection(bslib::font_google("JetBrains Mono", local = FALSE), "Menlo", "monospace"),
      "body-bg" = "#f7f9fb",
      "primary" = "#2c7a7b"
    ),
    shinyjs::useShinyjs(),
    htmltools::tags$head(
      htmltools::tags$link(rel = "stylesheet", href = "styles.css"),
      htmltools::tags$script(src = "replay.js")
    ),
    htmltools::tags$div(
      class = "app-shell",
      bslib::layout_columns(
        col_widths = c(3, 6, 3),
        gap = "1rem",
        ui_session_picker(),
        ui_replay_viewport(),
        ui_metadata_panel()
      )
    )
  )
}

ui_session_picker <- function() {
  htmltools::tags$div(
    class = "panel panel-picker",
    htmltools::tags$div(
      class = "picker-header",
      htmltools::tags$div(class = "app-title", "Clinical AI Agent"),
      htmltools::tags$div(class = "app-subtitle-small", "Demo Replays"),
      htmltools::tags$p(
        class = "app-blurb",
        "Pre-recorded sessions. Watch an AI agent search FDA documents, ",
        "clinical trials, and the biomedical literature."
      )
    ),
    htmltools::tags$div(class = "picker-list-label", "Sessions"),
    htmltools::tags$div(
      class = "picker-list",
      uiOutput("session_list", inline = FALSE)
    ),
    htmltools::tags$div(
      class = "picker-footer",
      htmltools::tags$a(href = "?about", "About this demo →")
    )
  )
}

ui_replay_viewport <- function() {
  htmltools::tags$div(
    class = "panel panel-viewport",
    htmltools::tags$div(
      class = "viewport-topbar",
      htmltools::tags$div(class = "viewport-title", textOutput("viewport_title", inline = TRUE)),
      htmltools::tags$div(
        class = "viewport-controls",
        actionButton("btn_play", label = "Play", class = "btn btn-primary btn-sm"),
        actionButton("btn_pause", label = "Pause", class = "btn btn-outline-secondary btn-sm"),
        actionButton("btn_restart", label = "Restart", class = "btn btn-outline-secondary btn-sm"),
        htmltools::tags$div(
          class = "speed-selector",
          htmltools::tags$label("Speed", class = "speed-label"),
          selectInput(
            "playback_speed", label = NULL,
            choices = c("1x" = 1, "2x" = 2, "4x" = 4),
            selected = 1, width = "80px"
          )
        )
      )
    ),
    htmltools::tags$div(
      id = "viewport_scroll", class = "viewport-scroll",
      htmltools::tags$div(id = "viewport_stream", class = "viewport-stream"),
      htmltools::tags$div(
        id = "viewport_empty", class = "viewport-empty",
        htmltools::tags$div(class = "empty-headline", "Press Play to start"),
        htmltools::tags$div(
          class = "empty-sub",
          "A pre-recorded agent session will stream in this viewport."
        )
      ),
      htmltools::tags$div(
        id = "viewport_thinking", class = "viewport-thinking",
        style = "display:none;",
        htmltools::tags$span(class = "thinking-dot"),
        htmltools::tags$span(class = "thinking-dot"),
        htmltools::tags$span(class = "thinking-dot"),
        htmltools::tags$span(class = "thinking-label", "agent is thinking")
      )
    )
  )
}

ui_metadata_panel <- function() {
  htmltools::tags$div(
    class = "panel panel-metadata",
    htmltools::tags$div(class = "metadata-section",
      htmltools::tags$div(class = "metadata-label", "This session"),
      uiOutput("metadata_stats")
    ),
    htmltools::tags$div(class = "metadata-section",
      htmltools::tags$details(
        htmltools::tags$summary("About this session"),
        uiOutput("metadata_about")
      )
    ),
    htmltools::tags$div(
      class = "metadata-footer",
      htmltools::tags$div(class = "footer-label", "Want to run your own?"),
      htmltools::tags$p(
        class = "footer-text",
        "These sessions were generated using Paperclip and Claude Code. ",
        "To run your own queries, see ",
        htmltools::tags$a(href = "https://paperclip.gxl.ai", target = "_blank", "Paperclip docs"),
        "."
      )
    )
  )
}
