# install.packages("hexSticker")
# https://thenounproject.com/icon/document-4959325/

library(hexSticker)

hexSticker::sticker("man/figures/sticker3.png",
                    package="legislators",
                    p_size=24,
                    p_x = 1,
                    p_y = .6,
                    s_x=1.0, s_y= 1.16, s_width=.82,
        filename="man/figures/logo.png",
        h_fill="#ffffff", h_color="#C5050C",
        p_color = "#C5050C")

