clockwidget = wibox.widget.textbox() 

function update_clock() 
  clockwidget:set_markup("<span color='#FFBA51'>" .. os.date("%H:%M") .."</span>")
end

function PopupDate()
  naughty.destroy(popupdate)
  local capi = { mouse = mouse, screen = screen }
  local date = "<span color='#FFBA51'>".. os.date("%a").. "</span><span color='#70B78F'> ".. os.date("%d").. " ".. os.date("%b").. " ".. os.date("%Y").. "</span>"
  popupdate = naughty.notify({
                title = "╔╣Date║",
                text = "╚>" ..date,
                timeout = 0,
                hover_timeout = 0.5,
                screen = capi.mouse.screen
        })  
end

clockwidget:buttons(awful.button({ }, 1, function () PopupDate() end))
clockwidget:connect_signal("mouse::leave", function () naughty.destroy(popupdate) end)

ClockTimer = timer({ timeout = 10 })
ClockTimer:connect_signal("timeout", function() update_clock() end)
ClockTimer:start()
