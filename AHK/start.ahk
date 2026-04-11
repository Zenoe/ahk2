SetTitleMatchMode(2)
#Include "C:\dotfiles\AHK\Common.ahk"

#Include "c:/dotfiles/AHK/func.ahk"
#Include "c:/dotfiles/AHK/git.ahk"

#HotIf WinActive("ahk_class TscShellContainerClass", )
  Capslock::           ; (couldn't make Ctrl(+Shift)+Caps Lock work for some reason
{ ; V1toV2: Added opening brace for [Capslock]
global ; V1toV2: Made function global
    ; Need a short sleep here for focus to restore properly.
    Sleep(50)
    WinMinimize("A")    ; need A to specify Active window
    ;MsgBox, Received Remote Desktop minimize hotkey    ; uncomment for debugging
  return
} ; V1toV2: Added closing brace for [Capslock]
#HotIf

^Capslock::
{ ; V1toV2: Added opening brace for [^Capslock]
global ; V1toV2: Made function global
ActiveWinClass("TscShellContainerClass", "")
return
} ; V1toV2: Added closing brace for [^Capslock]
