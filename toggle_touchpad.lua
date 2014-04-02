function toggle_touchpad()
  touchpad_info = io.popen("/usr/bin/synclient"):read("*all")
  touchpad_state = string.gsub(string.match(touchpad_info, "TouchpadOff             = %d"), 
"TouchpadOff             = ","")
  if (touchpad_state == "0")  then
    naughty.notify({text           = "TouchPad off",
                    timeout        = 1,
                    position       = "top_left",
                    ontop          = true,
                    hover_timeout  = true,
                    fg             = "#FA4F4F",
                    bg             = beautiful.bg_focus
                  })
    os.execute("/usr/bin/synclient TouchpadOff=1")
  elseif (touchpad_state == "1") then
    naughty.notify({text           = "TouchPad on",
                    timeout        = 1,
                    position       = "top_left",
                    ontop          = true,
                    hover_timeout  = true,
                    fg             = "#5BFA4F",
                    bg             = beautiful.bg_focus
                 })
    os.execute("/usr/bin/synclient TouchpadOff=0")
  end
end
