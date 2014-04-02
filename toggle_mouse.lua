function toggle_mouse()
  mouse_info_touch = io.popen("xinput --list-props 'Bluetooth Laser Travel Mouse'"):read("*all")
  mouse_info_mouse = io.popen("xinput --list-props 'SynPS/2 Synaptics TouchPad'"):read("*all")
  mouse_state_touch = string.match(mouse_info_touch, "%s%d")
  mouse_state_mouse = string.match(mouse_info_mouse, "%s%d")
  if (mouse_state_touch == "	1")or(mouse_state_mouse == "    1")  then
    naughty.notify({text           = "Mouse off",
                    timeout        = 1,
                    position       = "top_left",
                    ontop          = true,
                    hover_timeout  = true,
                    fg             = "#FA4F4F",
                    bg             = beautiful.bg_focus
                  })
    mouse.coords({ x=4000, y=2000 })
    os.execute("xinput set-int-prop 'Bluetooth Laser Travel Mouse' \"Device Enabled\" 8 0")
    os.execute("xinput set-int-prop 'SynPS/2 Synaptics TouchPad' \"Device Enabled\" 8 0")
  elseif (mouse_state_touch == "	0")or(mouse_state_mouse == "       0") then
    naughty.notify({text           = "Mouse on",
                    timeout        = 1,
                    position       = "top_left",
                    ontop          = true,
                    hover_timeout  = true,
                    fg             = "#5BFA4F",
                    bg             = beautiful.bg_focus
                  })
    os.execute("xinput set-int-prop 'Bluetooth Laser Travel Mouse' \"Device Enabled\" 8 1")
    os.execute("xinput set-int-prop 'SynPS/2 Synaptics TouchPad' \"Device Enabled\" 8 1")
  end
end
