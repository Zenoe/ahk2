SetTitleMatchMode(2)
#Include "C:\dotfiles\AHK\Common.ahk"

#Include "c:/dotfiles/AHK/func.ahk"
#Include "c:/dotfiles/AHK/git.ahk"

#HotIf WinActive("ahk_class TscShellContainerClass", )
  Capslock::           ; (couldn't make Ctrl(+Shift)+Caps Lock work for some reason
{ 
global 
    ; Need a short sleep here for focus to restore properly.
    Sleep(50)
    WinMinimize("A")    ; need A to specify Active window
    ;MsgBox, Received Remote Desktop minimize hotkey    ; uncomment for debugging
  return
} 
#HotIf

^Capslock::
{
ActiveWinClass("TscShellContainerClass", "")
return
}
:*:;wy::2004lzy156@163.com
:*:;ub::192.168.1.102
:*:;sa::192.168.1.127
:*:;pw::Xykj@$0325%
