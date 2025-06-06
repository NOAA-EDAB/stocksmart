#' hexSticker creation
#'
create_hex <- function() {

  imgurl <- here::here("data-raw", "book-reader-solid.svg")
  hexSticker::sticker(subplot = imgurl,
                      s_x = 1,
                      s_y = 1.3,
                      #s_width=0.5,
                      #s_height=0.9,
                      # package name
                      package = "stocksmart",
                      p_size = 20,
                      p_x = 1,
                      p_y = .7,
                      p_color = "#FFFFFF",

                      # hex border
                      h_size = 1,
                      h_fill = "#004395",
                      h_color = "#0093d0",
                      #angle = 30,
                      # splotlight
                      spotlight = FALSE,
                      l_x = .8,
                      l_y = 1,
                      l_width = 3,
                      l_height = 3,
                      l_alpha = 0.5,
                      # url
                      url = "noaa-edab.github.io/stocksmart",
                      u_x = 1,
                      u_y = .08,
                      u_size = 5.0,
                      white_around_sticker = T,
                      filename = here::here("man/figures", "logo.png"))
}
