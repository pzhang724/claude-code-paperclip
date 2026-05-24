load_index <- function(path = "transcripts/_index.json") {
  if (!file.exists(path)) {
    return(list(sessions = list()))
  }
  jsonlite::fromJSON(path, simplifyVector = FALSE)
}

load_transcript <- function(session_id, dir = "transcripts") {
  path <- file.path(dir, paste0(session_id, ".json"))
  if (!file.exists(path)) {
    return(NULL)
  }
  jsonlite::fromJSON(path, simplifyVector = FALSE)
}

event_delay_ms <- function(event, default = 500L) {
  d <- event$delay_ms
  if (is.null(d) || !is.numeric(d)) return(default)
  as.integer(d)
}

format_duration <- function(seconds) {
  if (is.null(seconds) || !is.numeric(seconds)) return("")
  mins <- floor(seconds / 60)
  if (mins < 1) return(paste0("~", round(seconds), " sec"))
  paste0("~", mins, " min")
}

audience_pills <- function(tags) {
  if (is.null(tags) || length(tags) == 0) return(NULL)
  htmltools::tagList(
    lapply(tags, function(t) {
      htmltools::tags$span(class = "audience-pill", t)
    })
  )
}

session_card <- function(meta, selected = FALSE) {
  htmltools::tags$div(
    class = paste0("session-card", if (selected) " session-card-selected" else ""),
    `data-session-id` = meta$id,
    onclick = sprintf("Shiny.setInputValue('selected_session', '%s', {priority: 'event'});", meta$id),
    htmltools::tags$div(class = "session-title", meta$title),
    if (!is.null(meta$subtitle))
      htmltools::tags$div(class = "session-subtitle", meta$subtitle),
    htmltools::tags$div(
      class = "session-meta-row",
      audience_pills(meta$audience_tags),
      htmltools::tags$span(
        class = "session-duration",
        htmltools::tags$span(class = "duration-icon", HTML("&#9201;")),
        format_duration(meta$estimated_duration_seconds)
      )
    )
  )
}
