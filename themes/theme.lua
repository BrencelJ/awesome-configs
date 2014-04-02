---------------------------
-- My awesome theme --
---------------------------

theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#131314"
theme.bg_focus      = "#212121"
theme.bg_urgent     = "#3FB573"
theme.bg_minimize   = "#2E2E2E"

theme.fg_normal     = "#ADADAD"
theme.fg_focus      = "#3FB573"
theme.fg_urgent     = "#2E2E2E"
theme.fg_minimize   = "#212121"

theme.border_width  = "1"
theme.border_normal = "#D6D6D6"
theme.border_focus  = "#84BA9C"
theme.border_marked = "#D95050"

theme.menu_height = "10"
theme.menu_width  = "100"

theme.tasklist_disable_icon = true

-- You can use your own command to set your wallpaper
theme.wallpaper = config .. "/themes/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = images .."fairh.png"
theme.layout_floating  = images .. "floating.png"
theme.layout_tile = images .. "tile.png"
theme.layout_tiletop = images .. "tiletop.png"

return theme
