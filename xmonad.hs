import XMonad
import XMonad.Util.EZConfig ( additionalKeys )
import XMonad.Util.Run( spawnPipe )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.ToggleLayouts
import System.IO ( hPutStrLn )

-- define the mod mask as a variable to be used in the keybindings and the basic settings as well 
myModMask = mod4Mask

-- define the list of my custom key bindings to add to xmonad
myKeyBindings = 
	[
		( ( myModMask, xK_r ), spawn "dmenu_run" ),
		( ( myModMask, xK_l ), spawn "xlock -mode forest" ),
		( ( myModMask, xK_Return ), spawn "terminator" ),
		( ( myModMask, xK_f ), sendMessage ToggleLayout ),
		( ( 0, 0x1008ff03 ), spawn "terminator" ), -- brightness down
		( ( 0, 0x1008ff02 ), spawn "terminator" ), -- brightness up
		( ( 0, 0x1008ff4a ), spawn "terminator" ) -- toggle the tray and the xmobar
	]

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"
themeBackground = "#3c3b37"
themeHighlight  = "#f07746"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- A standard tiled layout, with a master pane and a secondary pane off to
-- the side.  The master pane typically holds one window; the secondary
-- pane holds the rest.  Copied from standard xmonad.hs template config.
tiledLayout = Tall nmaster delta ratio
	where
		nmaster = 1      -- The default number of windows in the master pane.
		ratio   = 1/2    -- Default proportion of screen occupied by master pane.
		delta   = 3/100  -- Percent of screen to increment by when resizing panes.

-- configure the main behavior
main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaultConfig {
		-- set the default terminal emulator
		terminal = "terminator",

		-- set the meta key used for the xmonad commands
		modMask = myModMask,

		--
		manageHook = manageDocks <+> manageHook defaultConfig,

		--
		layoutHook = avoidStruts  $  layoutHook defaultConfig,

		--
		logHook = dynamicLogWithPP $ xmobarPP {
			ppOutput = hPutStrLn xmproc,
			ppTitle = xmobarColor xmobarTitleColor "" . shorten 100,
			ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "",
			ppSep = "   ",
			ppUrgent = xmobarColor "red" themeHighlight
		},

		-- set some workspace names
		workspaces = [ "1:term", "2:www", "3:dev" ] ++ map show [4..9],

		-- set a custom window manager name to help some apps to deal with xmonad
		startupHook = setWMName "LG3D",

		-- set the border for the windows which are open
		borderWidth = 0
	} `additionalKeys` myKeyBindings
