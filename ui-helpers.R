share <- list(
  title = "timevis - An R package for creating timeline visualizations",
  url = "http://daattali.com/shiny/timevis-demo/",
  image = "http://daattali.com/shiny/img/timevis-demo.png",
  description = "Create rich and fully interactive timeline visualizations. Timelines can be included in Shiny apps and R markdown documents, or viewed from the R console and RStudio Viewer.",
  twitter_user = "daattali"
)

codeConsole <-
'library(timevis)

data <- data.frame(
  id      = 1:4,
  content = c("Item one", "Item two",
              "Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11",
              "2016-01-20", "2016-02-14 15:00:00"),
  end     = c(NA, NA, "2016-02-04", NA)
)

timevis(data)'


