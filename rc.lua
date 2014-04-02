-- Standard awesome library
gears		= require("gears")
awful		= require("awful")
awful.rules	= require("awful.rules")
		require("awful.autofocus")
wibox		= require("wibox")
lain		= require("lain")
beautiful	= require("beautiful")
naughty		= require("naughty")
menubar		= require("menubar")
minitray	= require("minitray")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
file_manager = "ranger"
file_manager_cmd = terminal .. " -e " .. file_manager
config = awful.util.getdir("config")
images = config .. "/icons/"

-- Default modkey.
modkey = "Mod4"

-- Themes define colours, icons, and wallpapers
beautiful.init(config .. "/themes/theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
if screen.count() == 1 then
  tag = {
    names  = { "term", "web", "media", "chat", "music", "news", "torr", "game", "misc"},
    layout = { layouts[3], layouts[2], layouts[1], layouts[2], layouts[3], layouts[2], layouts[3], layouts[2], layouts[1]
  }}
  tag = awful.tag(tag.names, 1, tag.layout)
elseif screen.count() == 2 then
  tag_one = { 
    names  = { "term", "chat", "music", "game", "misc"},
    layout = { layouts[3], layouts[2], layouts[2], layouts[1], layouts[1]},
  }
  tag_two = { 
    names  = { "web", "media", "news", "torr", "misc"},
    layout = { layouts[2], layouts[1], layouts[3], layouts[2], layouts[1]},
  }
  tag_one = awful.tag(tag_one.names, 1, tag_one.layout)
  tag_two = awful.tag(tag_two.names, 2, tag_two.layout)
else
  tags = { 
    names  = { "1", "2", "3", "4", "5", "6", "7", "8", "9"},
    layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1]
  }}
  for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
  end 
end
-- }}}

-- {{{ Wibox
-- Create a textclock widget
require("clockrc")
-- Create brightness image widget
require("brightnessrc")
-- Create alsa volume widget
require("volumerc")
-- Create battery widget
require("batteryrc")
-- Create network (UL/DL) widget
require("networkrc")
-- Create icon for devices that are plugged in
require("pluggablesrc")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(imagepluggableswidget)
    right_layout:add(wibox.widget.textbox("│"))
    right_layout:add(mylayoutbox[s])
    right_layout:add(wibox.widget.textbox("│"))
    right_layout:add(imagedownloadnetworkwidget)
    right_layout:add(textdownloadnetworkwidget)
    right_layout:add(textuploadnetworkwidget)
    right_layout:add(imageuploadnetworkwidget)
    right_layout:add(wibox.widget.textbox("│"))
    right_layout:add(imagebatterywidget)
    right_layout:add(wibox.widget.textbox("│"))
    right_layout:add(imagevolumewidget)
    right_layout:add(textbrightnesswidget)
    right_layout:add(imagebrightnesswidget)
    right_layout:add(wibox.widget.textbox("│"))
    right_layout:add(clockwidget)
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- Create Mouse and Key bindings
require("bindingsrc")

-- {{{ Rules
if screen.count() == 1 then
  awful.rules.rules = {
      { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       keys = clientkeys,
                       buttons = clientbuttons } },
       { rule = { class = "Chromium"},
         properties = { tag = tag[2] } },
       { rule = { class = "Vlc" },
         properties = { tag = tag[3] } },
       { rule = { class = "Skype" },
         properties = { tag = tag[4] } },
       { rule = { class = "Transmission" },
         properties = { tag = tag[7] } },
       { rule = { class = "Steam" },
         properties = { tag = tag[8] } },
       { rule = { class = "Playonlinux" },
         properties = { tag = tag[8] } },
  }
elseif screen.count() == 2 then
  awful.rules.rules = {
      { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       keys = clientkeys,
                       buttons = clientbuttons } },
       { rule = { class = "Chromium"},
         properties = { tag = tag_two[1] } },
       { rule = { class = "Vlc" },
         properties = { tag = tag_two[2] } },
       { rule = { class = "Skype" },
         properties = { tag = tag_one[2] } },
       { rule = { class = "Steam" },
         properties = { tag = tag_one[4] } },
       { rule = { class = "Playonlinux" },
         properties = { tag = tag_one[4] } },
       { rule = { class = "Transmission" },
         properties = { tag = tag_two[4] } },
  }
else
  awful.rules.rules = { 
      { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       keys = clientkeys,
                       buttons = clientbuttons } },
  }
end
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- Autostart applications
require("autostartrc")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
