    ; Default UI/Editor colors table (identified by Tomas)
    ; CPU $BF00 (file $3F00). Bytes: 00,03,00,01,0F,...
    ;   $BF01 = $03  editor text color
    ;   $BF02 = $00  editor background
    ;   $BF03 = $01  menu color
    ;   $BF04 = $0F  graphics editor on and off color 0F means 0 - on = black, F - off - light gray (backgroud)
    ;   0 = black
    ;   1 = white
    ;   2 = red
    ;   3 = cyan
    ;   4 = purple
    ;   5 = green
    ;   6 = blue
    ;   7 = yellow
    ;   8 = orange
    ;   9 = brown
    ;   A = pink
    ;   B = dark grey
    ;   C = grey
    ;   D = light green
    ;   E = light blue
    ;   F = light grey
    ; -------------------------------------------------------------

COLOR_BORDER = $0B
COLOR_TEXT_TEXT = $03
COLOR_TEXT_BACKGROUND = $00
COLOR_TEXT_MENU = $01
COLOR_GRAPHIC_TEXT = $00
COLOR_GRAPHIC_BACKGROUND = $0F