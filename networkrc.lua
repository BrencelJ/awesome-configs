local network_card = "wlan0"

function DownloadUpload(name,dl_ul)
  for line in io.lines("/proc/net/dev") do
    local check_name = string.match(line, "^[%s]?[%s]?[%s]?[%s]?([%w]+):")
    if name == check_name then
      if dl_ul == "dl" then data = tonumber(string.match(line, ":[%s]*([%d]+)"))
      elseif dl_ul == "ul" then data = tonumber(string.match(line, "([%d]+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d$")) end
      return data
    end 
  end 
end

function TransmissionStats(dl_ul)
  local size = DownloadUpload(network_card,dl_ul) 
  if size > 1024 then
    size = size/1024
    if size > 1024 then
      size = size/1024
      if size > 1024 then
        size = size/1024
        return string.format("%.1f", size) .. " GB"
      else
        return string.format("%.1f", size) .. " MB"
      end
    else
      return string.format("%.1f", size) .. " KB"
    end
  else
    return string.format("%.1f", size) .. " B"
  end
end

function PopupStats()
    naughty.destroy(popupnetwork)
    local capi = { mouse = mouse, screen = screen }
    local get_lan = io.popen("ifconfig ".. network_card):read("*all")
    local lan = string.match(get_lan, "inet (%d+%p%d+%p%d+%p%d+)")
      info = "║<br>╠>Lan-IP: <span color='#FFBA51'>" .. lan  .. "</span><br>╠>Wan-IP: <span color='#FFBA51'>" .. io.open("/home/brencelj/.config/awesome/.wan_ip"):read("*all") .. "</span>║<br>╠>Download: <span color='#3FB573'>" .. TransmissionStats("dl") .. "</span><br>╚>Upload: <span color='#4AA8BA'>".. TransmissionStats("ul") .. "</span>"
    popupnetwork = naughty.notify({ title = "╔╣Network Stats║",
                             text = info,
                             timeout = 0,
                             hover_timeout = 0.5,
                             screen = capi.mouse.screen})
end

textdownloadnetworkwidget = wibox.widget.textbox()
textuploadnetworkwidget = wibox.widget.textbox()
imagedownloadnetworkwidget = wibox.widget.imagebox()
imageuploadnetworkwidget = wibox.widget.imagebox()
imagedownloadnetworkwidget:set_image(images .. "download.png")
imageuploadnetworkwidget:set_image(images .. "upload.png")
textdownloadnetworkwidget = lain.widgets.net({settings = function() widget:set_markup("<span color='#3FB573'>" .. net_now.received .. "</span> - <span color='#4AA8BA'>".. net_now.sent .. "</span>" ) end })
imagedownloadnetworkwidget:buttons(awful.button({ }, 1, function () PopupStats() end))
imagedownloadnetworkwidget:connect_signal("mouse::leave", function () naughty.destroy(popupnetwork) end)
imageuploadnetworkwidget:buttons(awful.button({ }, 1, function () PopupStats() end))
imageuploadnetworkwidget:connect_signal("mouse::leave", function () naughty.destroy(popupnetwork) end)
textdownloadnetworkwidget:buttons(awful.button({ }, 1, function () PopupStats() end))
textdownloadnetworkwidget:connect_signal("mouse::leave", function () naughty.destroy(popupnetwork) end)
textuploadnetworkwidget:buttons(awful.button({ }, 1, function () PopupStats() end))
textuploadnetworkwidget:connect_signal("mouse::leave", function () naughty.destroy(popupnetwork) end)
