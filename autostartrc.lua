function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
    if findme == "urxvt" then
--      findme = cmd:sub(firstspace+4)
      findapp = cmd:sub(firstspace+4)
      space = findapp:find(" ")
      if space then
        findme = findapp:sub(0, space-1)
      else
        findme = findapp
      end
    end
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("urxvt")
run_once("urxvt -e ranger")
run_once("urxvt -e htop")
run_once("urxvt -e bmon -U -p wlan0")
run_once("smplayer")
run_once("skype")
run_once("chromium")
run_once("transmission-gtk")
