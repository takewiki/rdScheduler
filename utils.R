# generate a random string of 16 characters
randomID <- function() {
  paste(sample(c(letters, LETTERS, 0:9), 16, replace = TRUE), collapse = "")
}

prettyDate <- function(d,offset=8) {
  value = as.POSIXct(gsub("T", " ", d), "%Y-%m-%d %H:%M")
  hour_offset = offset *60*60
  value2 = value + hour_offset
  
  res = suppressWarnings(format(value2))
}
