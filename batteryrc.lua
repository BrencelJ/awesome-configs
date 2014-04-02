imagebatterywidget = wibox.widget.imagebox()

function BatteryImage()
  file_energy_now = io.open("/sys/class/power_supply/BAT1/energy_now")
  if not file_energy_now then 
    open_energy_now = "1"
    file_energy_now = ""
  else open_energy_now = file_energy_now:read() end
  file_energy_full = io.open("/sys/class/power_supply/BAT1/energy_full")
  if not file_energy_full then 
    open_energy_full = "1"
    file_energy_full = ""
  else open_energy_full = file_energy_full:read() end
  file_status = io.open("/sys/class/power_supply/AC/online")
  open_status = file_status:read()
  battery = math.floor(open_energy_now * 100 / open_energy_full)
  if open_status:match("1") then
    icon = images .. "ac.png"
  elseif open_status:match("0") then
    if battery <= 100 and battery > 75 then
      icon = mages .. "battery-hi.png"
    elseif battery <= 75 and battery > 40 then
      icon = images .. "battery-med.png"
    elseif battery <= 40 and battery > 15 then
      icon = images .. "battery-low.png"
    elseif battery <= 15 then
      icon = images .. "battery-empty.png"
    end
  end
  if open_energy_full > "1" then
    file_energy_now:close()
    file_energy_full:close()
  end
  file_status:close()
  imagebatterywidget:set_image(icon)
end

function PopupBat()
  naughty.destroy(popupbat)
  local capi = { mouse = mouse, screen = screen }
  file_energy_now = io.open("/sys/class/power_supply/BAT1/energy_now")
  if not file_energy_now then 
    open_energy_now = "1" 
    file_energy_now = ""
  else open_energy_now = file_energy_now:read() end 
  file_energy_full = io.open("/sys/class/power_supply/BAT1/energy_full")
  if not file_energy_full then 
    open_energy_full = "1" 
    file_energy_full = ""
  else open_energy_full = file_energy_full:read() end 
  file_status = io.open("/sys/class/power_supply/AC/online")
  open_status = file_status:read()
  battery = math.floor(open_energy_now * 100 / open_energy_full)
  if open_status:match("1") then
    if open_energy_full == "1" then battery = "No Battery"
    else battery = "<span color='blue'>" .. battery .. "%</span>" end 
  elseif open_status:match("0") then
    if battery <= 100 and battery > 75 then
      battery = "<span color='green'>" .. battery  .. "%</span>"
    elseif battery <= 75 and battery > 40 then
      battery = "<span color='yellow'>" .. battery  .. "%</span>"
    elseif battery <= 40 and battery > 15 then
      battery = "<span color='orange'>" .. battery  .. "%</span>"
    elseif battery <= 15 then
      battery = "<span color='red'>" .. battery .. "%</span>"
    end 
  end 
  if open_energy_full > "1" then
    file_energy_now:close()
    file_energy_full:close()
  end 
  file_status:close()
  popupbat = naughty.notify({
             title = "╔╣Battery║",
             text = "╚>" .. battery,
             timeout = 0,
             hover_timeout = 0.5,
             screen = capi.mouse.screen
        })  
end

function BatteryLow()
  file_energy_now = io.open("/sys/class/power_supply/BAT1/energy_now")
  if not file_energy_now then 
    open_energy_now = "1"
    file_energy_now = ""
  else open_energy_now = file_energy_now:read() end
  file_energy_full = io.open("/sys/class/power_supply/BAT1/energy_full")
  if not file_energy_full then 
    open_energy_full = "1"
    file_energy_full = ""
  else open_energy_full = file_energy_full:read() end
  file_status = io.open("/sys/class/power_supply/AC/online")
  open_status = file_status:read()
  battery = math.floor(open_energy_now * 100 / open_energy_full)
  if open_status:match("0") then
    if battery <= 10 then
      naughty.notify({title      = "<span color='White'>Battery Warning!</span>",
                      text       = "<span color='Gray'>Battery low!</span> <span color='red'>"..battery.."%</span> <span color='Gray'>left!</span>",
                      timeout    = 5,
                      position   = "top_right",
                      fg         = beautiful.fg_focus,
                      bg         = beautiful.bg_focus
                    })
    end
  end
  if open_energy_full > "1" then
    file_energy_now:close()
    file_energy_full:close()
  end
  file_status:close()
end

imagebatterywidget:buttons(awful.button({ }, 1, function () PopupBat() end))
imagebatterywidget:connect_signal("mouse::leave", function () naughty.destroy(popupbat) end)
BatteryTimer = timer({ timeout = 1})
BatteryTimer:connect_signal("timeout", function() BatteryImage() end)
BatteryTimer:start()
BatteryLowTimer = timer({ timeout = 10})
BatteryLowTimer:connect_signal("timeout", function() BatteryLow() end)
BatteryLowTimer:start()
