-- {{{ Config File for Awesome 3.5
-- by Han Xiao <justlaputa@gmail.com>
--
-- Derived from Adrian C. <anrxc@sysphere.org>:
--
-- http://git.sysphere.org/awesome-configs/
--
-- using vicious:
--
-- http://git.sysphere.org/vicious/
-- }}}

local use_vicious = false

-- {{{ Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- User libraries
local vicious
vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

local iwlist = require("utils.iwlist")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = err })
                             in_error = false
   end)
end
-- }}}

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"

local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()

-- Editors
local emacs_cmd = "emacs"
local subl_cmd = "subl3"
local eclipse_cmd = home .. "/dev/eclipse/eclipse"
local intellij_cmd = "intellij-idea-13-community"

local terminal_cmd = "gnome-terminal --hide-menubar --window"
local terminal_tmux_cmd = "gnome-terminal --hide-menubar --window --profile=tmux"
local terminal_tiny_cmd = "gnome-terminal --hide-menubar --window --profile=tmux-tiny-font"
local firefox_cmd = "firefox"
local aurora_cmd = "firefox-aurora"
local firefox_nightly_cmd = "firefox-nightly"
local firefox_dev_cmd = "firefox-developer"
local fm_cmd = "nautilus"
local chrome_cmd = "google-chrome-stable --disable-background-mode --disable-translate --purge-memory-button --password-store=basic"
local chrome_unstable_cmd = "google-chrome-unstable"
local chrome_dev_cmd = chrome_unstable_cmd .. " --user-data-dir=\"" .. home .. "/.config/google-chrome-unstable/devel\""
local startvm_cmd = "VBoxManage startvm 'Windows'"
local android_cmd = home .. "/dev/android-sdk/tools/android avd"
local lockscreen_cmd = "gnome-screensaver-command -l"
local poweroff_cmd = "sudo poweroff"
local reboot_cmd = "sudo reboot"
local screenshot_cmd = "scrot -e 'mv $f ~/Pictures/screenshots/'"
local screenshot_select_cmd = "scrot -s -e 'mv $f ~/Pictures/screenshots/'"

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/zenburn/theme.lua")

-- Window management layouts
layouts = {
  awful.layout.suit.floating,        --1 float
  awful.layout.suit.tile,            --2 title
  awful.layout.suit.tile.left,       --3 titie_left
  awful.layout.suit.tile.bottom,     --4 title_bottom
  awful.layout.suit.tile.top,        --5 top
  awful.layout.suit.fair,            --6 fair
  awful.layout.suit.fair.horizontal, --7 fair_horiz
  awful.layout.suit.spiral,          --8 spiral
  awful.layout.suit.spiral.dwindle,  --9 dwindle
  awful.layout.suit.max,             --10 max
  awful.layout.suit.max.fullscreen,  --11 fullscreen
  awful.layout.suit.magnifier        --12 magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
   for s = 1, scount do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
end
-- }}}

-- {{{ Tags
tags = {
   settings = {
      {
         names  = { "term", "editor", "editor2",
                    "web", "web2", "ide",
                    "ide2", "files", "vm",
                    "hide" },
         layout = { layouts[9], layouts[2], layouts[10],
                    layouts[1], layouts[7], layouts[1],
                    layouts[1], layouts[1], layouts[1],
                    layouts[1] }
      },
      {
         names  = { "term", "web", "web2",
                    "file", "doc" },
         layout = { layouts[10], layouts[1], layouts[7],
                    layouts[1], layouts[1] }
      }
   }
}

for s = 1, scount do
   tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layout)
   for i, t in ipairs(tags[s]) do
      awful.tag.setproperty(t, "mwfact", s ==1 and i==2 and 0.13  or  0.5)
      awful.tag.setproperty(t, "hide", (i == 9) and true)
   end
end
-- }}}

-- {{{ Wibox
--
-- {{{ Reusable separator
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
--
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")
-- }}}

-- {{{ Memory usage
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB)", 13)
-- }}}

-- {{{ Network usage
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_net)
upicon:set_image(beautiful.widget_netup)
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, '<span color="'
                    .. beautiful.fg_urgent ..'">${eno1 down_kb}</span> <span color="'
                    .. beautiful.fg_normal ..'">${eno1 up_kb}</span>', 3)
-- }}}

-- {{{ Date and time
dateicon = wibox.widget.imagebox()
dateicon:set_image(beautiful.widget_date)
-- Initialize widget
datewidget = wibox.widget.textbox()
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%m/%d %a %R", 61)
-- Register buttons
-- }}}

--{{{ Pulseaudio
local pulseicon = wibox.widget.imagebox()
pulseicon:set_image(beautiful.widget_vol)
-- Initialize widgets
local pulsewidget = wibox.widget.textbox()
local pulsebar    = awful.widget.progressbar()
local pulsebox    = wibox.layout.margin(pulsebar, 3, 1, 1, 1)

-- Progressbar properties
pulsebar:set_width(8)
pulsebar:set_height(12)
pulsebar:set_ticks(true)
pulsebar:set_ticks_size(2)
pulsebar:set_vertical(true)
pulsebar:set_background_color(beautiful.fg_off_widget)
pulsebar:set_color(beautiful.fg_widget)
-- Bar from green to red
pulsebar:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 30 },
     stops = { { 0, "#AECF96" }, { 1, "#FF5656" } } })

-- Enable caching
vicious.cache(vicious.contrib.pulse)

local audio_card = "alsa_output.pci-0000_00_1b.0.analog-stereo"

local function pulse_volume(delta)
  vicious.contrib.pulse.add(delta, audio_card)
  vicious.force({ pulsewidget, pulsebar})
end

local function pulse_toggle()
  vicious.contrib.pulse.toggle(audio_card)
  vicious.force({ pulsewidget, pulsebar})
end

vicious.register(pulsebar, vicious.contrib.pulse, "$1", 20, audio_card)
vicious.register(pulsewidget, vicious.contrib.pulse,
function (widget, args)
  print('widget vol: '..args[1])
  return string.format("%.f%%", args[1])
end, 20, audio_card)

pulsewidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function() pulse_toggle() end),
  awful.button({ }, 4, function() pulse_volume(5) end), -- scroll up
  awful.button({ }, 5, function() pulse_volume(-5) end))) -- scroll down

pulsebar:buttons(pulsewidget:buttons())
pulseicon:buttons(pulsewidget:buttons())
--}}}

--{{{ Wifi
local wifiwidget = wibox.widget.textbox()
local wifiicon   = wibox.widget.imagebox()
local wifitooltip= awful.tooltip({})
wifitooltip:add_to_object(wifiwidget)
wifiicon:set_image(beautiful.widget_wifi)
vicious.register(wifiwidget, vicious.widgets.wifi,
  function(widget, args)
     local tooltip = ("<b>mode</b> %s <b>chan</b> %s <b>rate</b> %s Mb/s"):format(
                args["{mode}"], args["{chan}"], args["{rate}"])
     local quality = 0
     if args["{linp}"] > 0 then
        quality = args["{link}"] / args["{linp}"] * 100
     end
     wifitooltip:set_markup(tooltip)
     return ("%s: %.1f%%"):format(args["{ssid}"], quality)
  end, 5, "wlp1s0")

wifiicon:buttons( wifiwidget:buttons(awful.util.table.join(
awful.button({}, 1, function()
local networks = iwlist.scan_networks("wlp1s0")
if #networks > 0 then
  local msg = {}
  for i, ap in ipairs(networks) do
    local line = "<b>ESSID:</b> %s <b>MAC:</b> %s <b>Qual.:</b> %.2f%% <b>%s</b>"
    local enc = iwlist.get_encryption(ap)
    msg[i] = line:format(ap.essid, ap.address, ap.quality, enc)
  end
  naughty.notify({text = table.concat(msg, "\n")})
else
end
end),
awful.button({ "Shift" }, 1, function ()
-- restart-auto-wireless is just a script of mine,
-- which just restart netcfg
local wpa_cmd = "sudo restart-auto-wireless && notify-send 'wpa_actiond' 'restarted' || notify-send 'wpa_actiond' 'error on restart'"
awful.util.spawn_with_shell(wpa_cmd)
end), -- left click
awful.button({ }, 3, function ()  vicious.force{wifiwidget} end) -- right click
)))
--}}}


-- {{{ System tray
systray = wibox.widget.systray()
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
                   if c == client.focus then
                      c.minimized = true
                   else
                      -- Without this, the following
                      -- :isvisible() makes no sense
                      c.minimized = false
                      if not c:isvisible() then
                         awful.tag.viewonly(c:tags()[1])
                      end
                      -- This will also un-minimize
                      -- the client, if needed
                      client.focus = c
                      c:raise()
                   end
   end),
   awful.button({ }, 3, function ()
                   if instance then
                      instance:hide()
                      instance = nil
                   else
                      instance = awful.menu.clients({ width=250 })
                   end
   end),
   awful.button({ }, 4, function ()
                   awful.client.focus.byidx(1)
                   if client.focus then client.focus:raise() end
   end),
   awful.button({ }, 5, function ()
                   awful.client.focus.byidx(-1)
                   if client.focus then client.focus:raise() end
end))

for s = 1, scount do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ screen = s,
                              fg = beautiful.fg_normal, height = 12,
                              bg = beautiful.bg_normal, position = "top",
                              border_color = beautiful.border_focus,
                              border_width = beautiful.border_width
   })

   -- Left widgets
   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(mytaglist[s])
   left_layout:add(mylayoutbox[s])
   left_layout:add(separator)
   left_layout:add(mypromptbox[s])

   -- Right widges
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(dnicon)
   right_layout:add(netwidget)
   right_layout:add(upicon)
   right_layout:add(separator)
--   right_layout:add(wifiicon)
--   right_layout:add(wifiwidget)
--   right_layout:add(separator)
   right_layout:add(cpuicon)
   right_layout:add(cpuwidget)
   right_layout:add(separator)
   right_layout:add(memicon)
   right_layout:add(memwidget)
   right_layout:add(separator)
   right_layout:add(pulseicon)
   right_layout:add(pulsewidget)
   right_layout:add(pulsebox)
   right_layout:add(separator)
   right_layout:add(dateicon)
   right_layout:add(datewidget)
   right_layout:add(separator)
   if s == 1 then right_layout:add(systray) end

   -- Concat all widgets with task list in middle
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(mytasklist[s])
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   -- {{{ Program launchers
   awful.key({ modkey,           }, "Return", function () exec(terminal_cmd) end),
   awful.key({ modkey, "Shift"   }, "Return", function () exec(terminal_tiny_cmd) end),
   awful.key({ modkey,           }, "e", function () exec(emacs_cmd) end),
   awful.key({ modkey,           }, "w", function () exec(firefox_cmd) end),
   awful.key({ modkey, "Shift"   }, "w", function () exec(firefox_dev_cmd) end),
   awful.key({ modkey,           }, "s", function () sexec(subl_cmd) end),
   awful.key({ modkey,           }, "i", function () exec(intellij_cmd) end),
   awful.key({ modkey,           }, "g", function () exec(chrome_cmd) end),
   awful.key({ modkey, "Shift"   }, "g", function () exec(chrome_dev_cmd) end),
   awful.key({ modkey,           }, "n", function () exec(fm_cmd) end),
   awful.key({ modkey,           }, "a", function () exec(android_cmd) end),
   awful.key({ modkey,           }, "v", function () exec(startvm_cmd) end),
   awful.key({ modkey,           }, "l", function () exec(lockscreen_cmd) end),
   awful.key({               }, "Print", function () exec(screenshot_cmd) end),
   awful.key({ modkey, "Shift"   }, "s", function () sexec(screenshot_select_cmd) end),

   awful.key({ modkey, "Control", "Shift"}, "p", function() exec(poweroff_cmd) end),
   awful.key({ modkey, "Control", "Shift"}, "r", function() exec(reboot_cmd) end),
   -- }}}

   -- {{{ Tag navigation
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ altkey,           }, "Tab", awful.tag.history.restore),
   -- }}}

   -- {{{ Client focus control
   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
   end),

   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.history.previous()
                if client.focus then
                   client.focus:raise()
                end
   end),
   awful.key({ modkey,           }, "p",
             function ()
                awful.screen.focus_relative(1)
   end),
   -- }}}

   -- {{{ Awesome control
   awful.key({ modkey, "Shift" }, "r", awesome.restart),
   awful.key({ modkey, "Shift" }, "q", awesome.quit),
   -- }}}

   -- {{{ Layout switch
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
   -- }}}

   -- {{{ Prompt
   awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

   awful.key({ modkey }, "x",
             function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                                 mypromptbox[mouse.screen].widget,
                                 awful.util.eval, nil,
                                 awful.util.getdir("cache") .. "/history_eval")
   end)
   -- }}}
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) exec("kill -KILL " .. c.pid)     end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
   end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, scount do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
                                      awful.key({ modkey }, "#" .. i + 9,
                                                function ()
                                                   local screen = mouse.screen
                                                   if tags[screen][i] then
                                                      awful.tag.viewonly(tags[screen][i])
                                                   end
                                      end),
                                      awful.key({ modkey, "Control" }, "#" .. i + 9,
                                                function ()
                                                   local screen = mouse.screen
                                                   if tags[screen][i] then
                                                      awful.tag.viewtoggle(tags[screen][i])
                                                   end
                                      end),
                                      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                                function ()
                                                   if client.focus and tags[client.focus.screen][i] then
                                                      awful.client.movetotag(tags[client.focus.screen][i])
                                                   end
                                      end),
                                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                                function ()
                                                   if client.focus and tags[client.focus.screen][i] then
                                                      awful.client.toggletag(tags[client.focus.screen][i])
                                                   end
   end))
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    keys = clientkeys,
                    size_hints_honor = false,
                    buttons = clientbuttons } },
   { rule = { class = "Firefox" , instance = "Navigator"},
     properties = { tag = tags[1][3] } },
   { rule = { class = "Firefox" , instance = "Firebug"},
     properties = { tag = tags[scount][2] } },
   { rule = { class = "Emacs" },
     properties = { tag = tags[1][2] } },
   { rule = { class = "Subl3" },
     properties = { tag = tags[1][2] } },
   { rule = { class = "Google-chrome-unstable" },
     properties = { tag = tags[scount][2] } },
   { rule = { class = "Google-chrome" },
     properties = { tag = tags[1][4] } },
   { rule = { class = "Eclipse" },
     properties = { tag = tags[1][5] } },
   { rule_any = { class = { "jetbrains-idea" } },
     properties = { tag = tags[1][6] } },
   { rule_any = { class = { "Atom" } },
     properties = { tag = tags[1][5] } },
   { rule_any = { class = { "VirtualBox" } },
     properties = { tag = tags[1][8] } },
   { rule_any = { class = { "libreoffice" } },
     properties = { tag = tags[1][4] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
                         -- Enable sloppy focus
                         c:connect_signal("mouse::enter", function(c)
                                             if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                             and awful.client.focus.filter(c) then
                                                client.focus = c
                                             end
                         end)

                         if not startup then
                            -- Set the windows at the slave,
                            -- i.e. put it at the end of others instead of setting it master.
                            -- awful.client.setslave(c)

                            -- Put windows in a smart way, only if they does not set an initial position.
                            if not c.size_hints.user_position and not c.size_hints.program_position then
                               awful.placement.no_overlap(c)
                               awful.placement.no_offscreen(c)
                            end
                         end

                         local titlebars_enabled = false
                         if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
                            -- Widgets that are aligned to the left
                            local left_layout = wibox.layout.fixed.horizontal()
                            left_layout:add(awful.titlebar.widget.iconwidget(c))

                            -- Widgets that are aligned to the right
                            local right_layout = wibox.layout.fixed.horizontal()
                            right_layout:add(awful.titlebar.widget.floatingbutton(c))
                            right_layout:add(awful.titlebar.widget.maximizedbutton(c))
                            right_layout:add(awful.titlebar.widget.stickybutton(c))
                            right_layout:add(awful.titlebar.widget.ontopbutton(c))
                            right_layout:add(awful.titlebar.widget.closebutton(c))

                            -- The title goes in the middle
                            local title = awful.titlebar.widget.titlewidget(c)
                            title:buttons(awful.util.table.join(
                                             awful.button({ }, 1, function()
                                                             client.focus = c
                                                             c:raise()
                                                             awful.mouse.client.move(c)
                                             end),
                                             awful.button({ }, 3, function()
                                                             client.focus = c
                                                             c:raise()
                                                             awful.mouse.client.resize(c)
                                             end)
                            ))

                            -- Now bring it all together
                            local layout = wibox.layout.align.horizontal()
                            layout:set_left(left_layout)
                            layout:set_right(right_layout)
                            layout:set_middle(title)

                            awful.titlebar(c):set_widget(layout)
                         end
end)

-- remove gaps between clients
size_hints_honor = false

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

sexec("workrave")
sexec("nm-applet")
sexec("rescuetime")
