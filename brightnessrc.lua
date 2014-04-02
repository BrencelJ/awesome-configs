imagebrightnesswidget = wibox.widget.imagebox()
textbrightnesswidget = wibox.widget.textbox()

function ConnectedDisplay()
  displays = {}
  check = 0
  xrandr = io.popen("xrandr -q")
  if xrandr then
    for line in xrandr:lines() do
      if check == 0 then
        output = line:match("^([%w-]+) connected ")
      else
        check = 0
        local connected = line:match("*+")
        if connected then
          displays[#displays + 1] = output
        end
        output = nil
      end
      if output then
        check = 1
      end
    end
    xrandr:close()
  end
  return displays
end

function BrightnessImage()
  local display = ConnectedDisplay()
  for i, choice in pairs(display) do
    if choice == "LVDS1" then brightness_img = true
    else brightness_img = false end
  end
    if brightness_img == true then
      open_brightness = io.open("/sys/class/backlight/acpi_video0/brightness"):read("*all")
      brightness_level = string.match(open_brightness, "%d")
      if brightness_level == "8" then icon = images .. "brightness-8.png"
      elseif brightness_level == "7" then icon = images .. "brightness-7.png"
      elseif brightness_level == "6" then icon = images .. "brightness-6.png"
      elseif brightness_level == "5" then icon = images .. "brightness-5.png"
      elseif brightness_level == "4" then icon = images .. "brightness-4.png"
      elseif brightness_level == "3" then icon = images .. "brightness-3.png"
      elseif brightness_level == "2" then icon = images .. "brightness-2.png"
      elseif brightness_level == "1" then icon = images .. "brightness-1.png"
      else icon = images .. "brightness-0.png" end
      imagebrightnesswidget:set_image(icon)
      textbrightnesswidget:set_text("│")
    end
end

BrightnessTimer = timer({ timeout = 1})
BrightnessTimer:connect_signal("timeout", function() BrightnessImage() end)
BrightnessTimer:start()
