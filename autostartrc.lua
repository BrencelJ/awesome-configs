function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
    if findme == "urxvt" then
      findme = cmd:sub(firstspace+4)
    end
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("urxvt")
run_once("urxvt -e ranger")
run_once("urxvt -e htop")
--run_once("urxvt -e sudo nethogs -d2 wlan0")
--run_once("udiskie --tray")
run_once("vlc")
run_once("skype")
run_once("chromium")
run_once("transmission-gtk")
