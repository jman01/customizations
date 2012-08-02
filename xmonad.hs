-- A very basic xmonad config. Created to just add the xmobar. everythign else is stock xmonad configuration. 
-- NOTE: Modify parth to .xmobarrc in line 20 as needed

import XMonad
import System.IO
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks

main = xmonad defaults


defaults = defaultConfig {
	logHook	=	myLogHook,
	manageHook =	myManageHook,
	layoutHook =	myLayoutHook
}

myLogHook = do
	xmproc <- spawnPipe "/usr/bin/xmobar /home/jdp/.xmobarrc"
	dynamicLogWithPP xmobarPP
        	{
		ppOutput = hPutStrLn xmproc
	        ,ppTitle = xmobarColor "green" "" . shorten 50
       	}

myManageHook = do
	manageDocks

myLayoutHook = do
	avoidStruts $ tile ||| Mirror tile ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tile   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
