render_event <- function(event, event_id) {
  type <- event$type %||% "agent_thought"
  switch(
    type,
    user_query       = render_user_query(event, event_id),
    agent_thought    = render_agent_thought(event, event_id),
    tool_call        = render_tool_call(event, event_id),
    tool_output      = render_tool_output(event, event_id),
    final_synthesis  = render_final_synthesis(event, event_id),
    pause            = render_pause(event, event_id),
    render_unknown(event, event_id)
  )
}

`%||%` <- function(a, b) if (is.null(a)) b else a

event_wrap <- function(event_id, class, ...) {
  htmltools::tags$div(
    id = paste0("event-", event_id),
    class = paste("event", class),
    ...
  )
}

render_user_query <- function(event, event_id) {
  event_wrap(
    event_id, "event-user-query",
    htmltools::tags$div(class = "user-bubble",
      htmltools::tags$div(class = "user-label", "Reviewer asked"),
      htmltools::tags$div(class = "user-content", event$content)
    )
  )
}

render_agent_thought <- function(event, event_id) {
  content <- event$content %||% ""
  event_wrap(
    event_id, "event-agent-thought",
    htmltools::tags$div(class = "thought-row",
      htmltools::tags$span(class = "thought-icon", HTML("&#9881;")),
      htmltools::tags$span(
        class = "thought-text",
        `data-typewriter` = "1",
        `data-typewriter-content` = content
      )
    )
  )
}

render_tool_call <- function(event, event_id) {
  tool_name <- event$tool_name %||% "tool"
  args <- event$args %||% ""
  event_wrap(
    event_id, "event-tool-call",
    htmltools::tags$div(class = "tool-call-header",
      htmltools::tags$span(class = "tool-call-arrow", HTML("&#8250;")),
      htmltools::tags$span(class = "tool-call-name", tool_name)
    ),
    htmltools::tags$pre(class = "tool-call-args",
      htmltools::tags$code(args)
    )
  )
}

render_tool_output <- function(event, event_id) {
  fmt <- event$format %||% "text"
  content <- event$content %||% ""
  event_wrap(
    event_id, "event-tool-output",
    htmltools::tags$div(class = "tool-output-header", "output"),
    htmltools::tags$pre(
      class = paste0("tool-output-body", if (fmt == "code") " tool-output-code" else ""),
      htmltools::tags$code(content)
    )
  )
}

render_final_synthesis <- function(event, event_id) {
  content <- event$content %||% ""
  html <- tryCatch(
    markdown::mark_html(text = content, template = FALSE),
    error = function(e) {
      tryCatch(markdown::markdownToHTML(text = content, fragment.only = TRUE),
               error = function(e) htmltools::HTML(htmltools::htmlEscape(content)))
    }
  )
  event_wrap(
    event_id, "event-final-synthesis",
    htmltools::tags$div(class = "final-label", "Synthesis"),
    htmltools::tags$div(class = "final-body", htmltools::HTML(as.character(html)))
  )
}

render_pause <- function(event, event_id) {
  event_wrap(event_id, "event-pause", htmltools::tags$div(class = "pause-spacer"))
}

render_unknown <- function(event, event_id) {
  event_wrap(
    event_id, "event-unknown",
    htmltools::tags$pre(
      htmltools::tags$code(jsonlite::toJSON(event, auto_unbox = TRUE, pretty = TRUE))
    )
  )
}
