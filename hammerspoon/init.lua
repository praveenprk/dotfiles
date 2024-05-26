local hyper = {"ctrl", "shift", "cmd"}

hs.loadSpoon("MiroWindowsManager")

------------------------------------------------------------------------------------------
--  Setting the nextscreen to 0 as it doesnt seem to work as expected in the documentation
------------------------------------------------------------------------------------------

hs.window.animationDuration = 0.13
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "u"},
  right = {hyper, "r"},
  down = {hyper, "d"},
  left = {hyper, "l"},
  fullscreen = {hyper, "f"},
  nextscreen = {hyper, "0"}
})

------------------------------------------------------------------------------------------
--  Got this code from the below link, essentially calling the undelying hammerspoon API call instead of using the MiroWindowsManager API for the same
--  https://github.com/miromannino/miro-windows-manager/commit/ed1c8b2989735a75b17378f3d2438e84cd38f49a#diff-23f5b0f791ff659076053794af7352afe2228301b71acc55b4449b04efee6963R123
------------------------------------------------------------------------------------------

hs.hotkey.bind(hyper, "n", function()
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
  end
end)

------------------------------------------------------------------------------------------
--  Adding the custom windows shortcuts
------------------------------------------------------------------------------------------

appShortcuts = {
	-- ['k'] = 'Slack',
	['p'] = 'System Preferences',
	['s'] = 'Safari',
	['t'] = 'Terminal',
  ['m'] = 'MongoDB Compass',
	['g'] = 'SourceTree',
  ['d'] = 'Discord',
	['c'] = 'Google Chrome',
	['v'] = 'Visual Studio Code',
	['z'] = 'Brave Browser',
	['a'] = 'Arc',
	['e'] = 'Emacs',
	['q'] = 'Sequel Pro',
	-- ['b'] = 'Brave Browser',
  ['x'] = 'Notes',
	['w'] = 'WhatsApp'
}


for appShortcut, appName in pairs(appShortcuts) do 
  hs.hotkey.bind(hyper, appShortcut, function()
    hs.application.launchOrFocus(appName)
  end)
end 

------------------------------------------------------------------------------------------
--  Show hints to allow easy switching between windows that are one below another
------------------------------------------------------------------------------------------

hs.hotkey.bind("cmd", "escape", function()
  hs.hints.windowHints()
end)


------------------------------------------------------------------------------------------
-- Toggle sleep mode of mac, most of the code is from
-- https://github.com/dbmrq/dotfiles/commit/2cd73731120b6790cec5951fa2495e54339892cb#diff-735f3074ba6afa350e04bc50cd192c54fa07906fe3374e785ef9183c02f0ea22R17
------------------------------------------------------------------------------------------

local caf = require "hs.caffeinate"

local menu

local function enable()
    caf.set("displayIdle", true, true)
    caf.set("systemIdle", true, true)
    if not menu then
        menu = hs.menubar.new()
    end
    menu:returnToMenuBar()
    menu:setTitle("42 ∞")
    menu:setTooltip("Disable Idle Sleep")
    menu:setClickCallback(function() disable() end)
end

function disable()
    caf.set("displayIdle", false, false)
    caf.set("systemIdle", false, false)
    menu:delete()
end

hs.hotkey.bind(hyper, "8", function() enable() end)
