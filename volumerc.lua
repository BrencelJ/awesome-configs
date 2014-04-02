imagevolumewidget = wibox.widget.imagebox()

function ChangeSpeaker (sound_card)
  sinks_all = io.popen("pactl list short sink-inputs")
  for line in sinks_all:lines() do
    sink_id = line:match("%d%d")
    os.execute("pactl move-sink-input ".. sink_id .. " " .. sound_card)
  end
end

function SoundCardUpdate ()
  sound_info = io.popen("aplay -l"):read("*all")
  if string.match(sound_info, 'Z%d+') == "Z305" then
    ChangeSpeaker ("alsa_output.usb-Logitech_Logitech_Z305-00-Z305.analog-stereo")
    cardid = string.match(sound_info, 'card (%d): Z%d+')
    channel = "PCM"
  else
    ChangeSpeaker ("alsa_output.pci-0000_00_1b.0.analog-stereo")
    cardid = string.match(sound_info, 'card (%d): %u+')
    channel = "Master"
  end 
end

function VolumeImage (mode)
  if mode == "update" then
    status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
    volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
    status_turn = string.match(status, "%[(o[^%]]*)%]")
    if string.find(status_turn, "on", 1, true) then
      if volume <= 100 and volume > 75 then icon = images .. "volume-hi.png"
      elseif volume <= 75 and volume > 50 then icon = images .. "volume-med.png"
      elseif volume <= 50 and volume > 25 then icon = images .. "volume-low.png"
      else icon = images .. "volume-quiet.png" end
    else icon = images .. "volume-mute.png" end  
    imagevolumewidget:set_image(icon)
  elseif mode == "up" then
    os.execute("amixer -q -c " .. cardid .. " sset " .. channel .. " 3%+")
    VolumeImage("update")
  elseif mode == "down" then
    os.execute("amixer -q -c " .. cardid .. " sset " .. channel .. " 3%-")
    VolumeImage("update")
  else
    os.execute("amixer -q -c " .. cardid .. " sset " .. channel .. " toggle")
    VolumeImage("update")
  end
end 

function PopupVolume()
  naughty.destroy(popupvolume)
  local capi = { mouse = mouse, screen = screen }
  sitatus = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
  volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
  status_turn = string.match(status, "%[(o[^%]]*)%]")
  if string.find(status_turn, "on", 1, true) then
    if volume <= 100 and volume > 66 then volume_text = "<span color='#DA5555'>" ..volume.. "%</span>"
    elseif volume <= 66 and volume > 33 then volume_text = "<span color='#DADA55'>" ..volume.. "%</span>"
    else volume_text = "<span color='#5578DA'>" ..volume.. "%</span>" end
  else volume_text = "<span color='#585858'>" ..volume.. "%</span>" end
  popupvolume = naughty.notify({
                title = "╔╣Volume║",
                text = "╚>" .. volume_text,
                timeout = 0,
                hover_timeout = 0.5,
                screen = capi.mouse.screen
        })  
end

imagevolumewidget:buttons(awful.button({ }, 1, function () PopupVolume() end))
imagevolumewidget:connect_signal("mouse::leave", function () naughty.destroy(popupvolume) end)

VolumeTimer = timer({ timeout = 1})
VolumeTimer:connect_signal("timeout", function() SoundCardUpdate() end)
VolumeTimer:connect_signal("timeout", function() VolumeImage("update") end)
VolumeTimer:start()
