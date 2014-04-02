function toggle_keyboard_backlight()
  file = io.open(config .. "/.keyboard_backligh", "r")
  if file~=nil then
    read = file:read()
    file:close()
  else
    read = "1"
  end
  if "0" == read  then
    os.execute("sudo " .. config .. "/scripts/kbd_lit -e")
    file = io.open(config .. "/.keyboard_backligh","w")
    file:write("1")
    file:close()
    naughty.notify({text           = "Backlight on",
                     timeout        = 1,
                     position       = "top_left",
                     ontop          = true,
                     hover_timeout  = true,
                     fg             = "#5BFA4F",
                     bg             = beautiful.bg_focus
                   })
  else
    os.execute("sudo " .. config .. "/scripts/kbd_lit -d")
    file = io.open(config .. "/.keyboard_backligh","w")
    file:write("0")
    file:close()
    naughty.notify({text           = "Backlight off",
                    timeout        = 1,
                    position       = "top_left",
                    ontop          = true,
                    hover_timeout  = true,
                    fg             = "#FA4F4F",
                    bg             = beautiful.bg_focus
                  })         
  end
end
