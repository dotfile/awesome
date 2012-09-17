Brandon's Awesome Window Manager Config
=======================================
I'm pretty happy with my ever-evolving Awesome setup. It's got some
nifty features that I've developed and borrowed. The first thing you'll
notice is that it's more modular than a single `rc.lua` file. I'm still
working on the organization of these files, but modularity is critical 
for both sharing and maintenance.

Some of my changes are opinionated, but it works for me. 

Here are some of the better features:
-------------------------------------
* Terminals spawn on the *same pwd* as the active client. My 
  favorite feature.
* *Greatly simplified AWM experience:* 
	* Only 4 tags, only the useful layouts, etc.
	* Pared down, and arguably better keybindings 
* Wallpaper rotation
* Gapless borders and current window highight
* Spawns one and only one instance of: 
	* Battery indicator
	* Sound applet 
	* Network manager applet

Key Bindings
------------
* **Meta+Enter** -- Spawn terminal on same pwd as active client
* **Meta+Ctrl+Enter** -- Spawn chromium
* ***Meta+(Right/Left)*** -- Move between tags
* ***Meta+Ctrl+(Right/Left)*** -- Move active client between tags
* **Meta+(j/k)** -- Switch active client
* **Meta+Ctrl+(j/k)** -- Move active client's position within tag
* **Meta+(h/l)** -- Move the divider dimensions for layout
* **Meta+Ctrl+l** -- Lock screen with xlock
* ***Meta+(1/2/3/4)*** -- Switch between layouts! (I feel this is 
  superior to the default keybinding.)
* **Meta+r** -- Run a command
* **Meta+Ctrl+r** -- Restart AWM (reloads the configs)

*Check `keybindings.lua` for a complete list*

TODO
----
* New colorschemes: molokai, lucius, ...
* Dark/light colorscheme switch that propagates to urxvt and vim
* Better font, topbar, etc. size management for different screen sizes
* Screenshot keybinding
* Find some better minimalistic apps for PDF reading, screenshots, etc.
* Add/remove tags as needed
* Auto-group clients to certain tags.

My other dotfiles and configs
-----------------------------
* [Bash configuration](https://github.com/echelon/dotfiles-bash)
* [Vim configuration](https://github.com/echelon/dotfiles-vim)
* [AwesomeWM configuration](https://github.com/echelon/dotfiles-awesome) *-- quite neat*

