local num = 0
function UpdatePluggables()
  local item = {}
  local item_menu = {}
  local i = 0
  imagepluggableswidget:set_image()
  for device in string.gmatch(io.popen("ls /media"):read("*all"), "[^%s]+") do
    if device ~= "storage" then
      item_menu = {{"Open", file_manager_cmd .. " /media/" .. device},
                   {"Unmount", "udiskie-umount -d /media/" .. device}
                  }
      item[i] = {device, item_menu} 
      i = i+1
      imagepluggableswidget:set_image(images .. "pluggables.png")
    end 
  end
  if i ~= num then
    pluggablesmenu = awful.menu({ items = item })
    num = i
  end
end 

imagepluggableswidget = wibox.widget.imagebox()
PluggablesTimer = timer({ timeout = 1 })
PluggablesTimer:connect_signal("timeout", function() UpdatePluggables() end)
PluggablesTimer:start()
imagepluggableswidget:buttons(awful.button({ }, 1, function () pluggablesmenu:toggle() end))
