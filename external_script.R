library("dplyr")
library("htmltools")

get_title_panel <- function() {
  h1("Amazon Inc.",
     tags$br(),
     tags$small("2019 Annual Report",
                class = "text-muted"))
}

exec_card_component <- function(name, title, portrait) {
  div(
    class = "card",
    img(class = "card-img-top",
        src = portrait,
        alt = name),
    div(
      class = "card-body",
      h5(class = "card-title",
         name),
      p(class = "card-text",
        title)
    )
  )
}

get_cards_component <- function(data) {
  data %>%
    purrr::pmap(exec_card_component) %>%
    div(class = "card-wrapper") %>%
    doRenderTags()
}
