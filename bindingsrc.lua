-- Toggle keyboard backlight on/off
require("toggle_keyboard_backlight")
-- Toggle mouse on/off
require("toggle_mouse")
-- Toggle touchpad on/off
require("toggle_touchpad")
-- Display 
require("displayrc")
-- Drop-down terminal
require ("dropdownrc")
local quake = require("quake")
local quakeconsole = {}
for s = 1, screen.count() do
   quakeconsole[s] = quake({ terminal = config.terminal,
   			     height = 0.90,
			     screen = s })
end

-- {{{ Mouse bindings
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "w", function () mymainmenu:show({keygrabber=true}) end),
-- Mouse toggle on/off
    awful.key({ modkey, }, "m", function () toggle_mouse() end),
-- TouchPad toggle on/off
    awful.key({ modkey, }, "t", function () toggle_touchpad() end),
-- Brightness up/down
    awful.key({ }, "#232",function() os.execute("sudo " .. config .. "/scripts/brightness_down") end),
    awful.key({ }, "#233",function() os.execute("sudo " .. config .. "/scripts/brightness_up") end),
-- Sleep
--    awful.key({ }, "#213",function() os.execute("sudo pm-suspend") end),
-- Keyboards backlight on/off
    awful.key({ }, "#146", function () toggle_keyboard_backlight() end),
-- VGA/HDMI
    awful.key({}, "XF86Display", function () xrander() end),
-- From laptop screen to 2 screens at home
    awful.key({ }, "#169",function() os.execute(config .. "/scripts/toggle_displays") end),
-- System tray toggle
    awful.key({ modkey,           }, "s", function() minitray.toggle() end ),
-- Drop-down console
    awful.key({ modkey }, "#65", function () quakeconsole[mouse.screen]:toggle() end),

-- Layout manipulation
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ "Mod1",           }, "Tab",
        function ()
              awful.client.focus.byidx( 1)
              if client.focus then client.focus:raise()
            end
        end),
-- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

-- Prompt
    awful.key({ "Mod1", },"F2",function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Control" }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
-- Menubar
    awful.key({ modkey }, "r", function() menubar.show() end),

-- Volume
    awful.key({ }, "#122",function() VolumeImage("down") end),
    awful.key({ }, "#123",function() VolumeImage("up") end),
    awful.key({ }, "#121",function() VolumeImage() end),
    awful.key({ modkey, "Shift" }, "-",function() VolumeImage("down") end),
    awful.key({ modkey, "Shift" }, "+",function() VolumeImage("up") end),

-- mpd music control
   awful.key({ modkey }, "<", function() awful.util.spawn( "ncmpcpp toggle" ) end),
   awful.key({ modkey }, "y", function() awful.util.spawn( "ncmpcpp prev" ) end),
   awful.key({ modkey }, "x", function() awful.util.spawn( "ncmpcpp next" ) end),
   awful.key({ modkey }, "-", function() awful.util.spawn( "ncmpcpp volume -5" ) end),
   awful.key({ modkey }, "+", function() awful.util.spawn( "ncmpcpp volume +5" ) end),
   awful.key({ modkey }, "o", 
   	     function()
	        if naughty.destroy(popupsong) ~= true then
		popupsong = naughty.notify({
			text = string.match(io.popen('ncmpcpp --now-playing "{%a - %t}|{%f}"'):read("*all"),"(.+)%s"),
			timeout = 5,
			screen = s
		})
		end
	     end),

-- Resize windows
    awful.key({ modkey, "Control"}, "Down",  function () awful.client.moveresize( 0,  0, 0, 15) end),
    awful.key({ modkey, "Control"}, "Up", function () awful.client.moveresize(0, 0,  0,  -5) end),
    awful.key({ modkey, "Control"}, "Left", function () awful.client.moveresize(0, 0,  -5,  0) end),
    awful.key({ modkey, "Control"}, "Right", function () awful.client.moveresize(0, 0, 10,  0) end),
-- Move windows
    awful.key({ modkey }, "Down",  function () awful.client.moveresize(  0,  5,   0,   0) end),
    awful.key({ modkey }, "Up",    function () awful.client.moveresize(  0, -5,   0,   0) end),
    awful.key({ modkey }, "Left",  function () awful.client.moveresize(-5,   0,   0,   0) end),
    awful.key({ modkey }, "Right", function () awful.client.moveresize( 5,   0,   0,   0) end)
)
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end)
)
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
if screen.count() == 1 then
  keynumber = math.min(9, math.max(#tag, keynumber));
elseif screen.count() == 2 then
   keynumber = math.min(5, math.max(#tag_one, keynumber));
else
  for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
  end
end
-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
-- Set keys
root.keys(globalkeys)
-- }}}
