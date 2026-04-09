#Include "c:/dotfiles/AHK/func.ahk"

; V1toV2: Removed #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; kill shift+space
<+space::
{ ; V1toV2: Added opening brace for [<+space]
global ; V1toV2: Made function global
return
} ; V1toV2: Added closing brace for [<+space]

#SingleInstance Force
SetTitleMatchMode(2)
;DetectHiddenWindows, on


;*************************************
cos_mousedrag_treshold := 20 ; pixels
#HotIf !WinActive("ahk_class ConsoleWindowClass")

; ~mbutton::
;   WinGetClass cos_class, A
;   if (cos_class == "Emacs")
;     SendInput ^y
;   else
;     SendInput ^v
;   return
  
#HotIf !WinActive()


;; clipx
^mbutton::
{ ; V1toV2: Added opening brace for [^mbutton]
global ; V1toV2: Made function global
  SendInput("^+{insert}")
  return
} ; V1toV2: Added closing brace for [^mbutton]

#i::Run("`"C:\Windows\system32\rundll32.exe`" sysdm.cpl,EditEnvironmentVariables")

#+i::Run("`"C:\WINDOWS\system32\rundll32.exe`" shell32.dll,Control_RunDLL sysdm.cpl")


<#v::
{ ; V1toV2: Added opening brace for [<#v]
global ; V1toV2: Made function global
ActiveWinClass("MozillaWindowClass", "C:\Program Files\Mozilla Firefox\firefox.exe")
;ActiveWinClass("VirtualConsoleClass", "C:\portable\cmder\Cmder.exe")
return
} ; V1toV2: Added closing brace for [<#v]

<#+v::
{ ; V1toV2: Added opening brace for [<#+v]
global ; V1toV2: Made function global
ActiveWinClass("VirtualConsoleClass", "C:\portable\cmder\Cmder.exe")
return
} ; V1toV2: Added closing brace for [<#+v]
<#a::
{
global ; V1toV2: Made function global
ActiveWinClass("Emacs", "C:\emacs\bin\runemacs.exe")
return
}

;**************Notepad
<#o::
{ ; V1toV2: Added opening brace for [<#o]
global ; V1toV2: Made function global
ActiveWinClass("Notepad", "Notepad")
return
} ; V1toV2: Added closing brace for [<#o]

<#+o::
{ ; V1toV2: Added opening brace for [<#+o]
global ; V1toV2: Made function global
Run("`"notepad`"")
return
} ; V1toV2: Added closing brace for [<#+o]

<#f::
{
global
ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe")
return
}

<#+f::
{
global ; V1toV2: Made function global
ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe", "Clipboard")
return
}

<#+s::
{ ; V1toV2: Added opening brace for [<#+s]
global ; V1toV2: Made function global
Run("regedit.exe")
return
} ; V1toV2: Added closing brace for [<#+s]

#n::
{
global

ActiveWinClass("HwndWrapper[DefaultDomain;;78a7241c-694f-4bf4-9937-12bde4b0ab5c]", "devenv.exe")
return
} ; V1toV2: Added closing brace for [#n]

#+c::
{ ; V1toV2: Added opening brace for [#+c]
global ; V1toV2: Made function global
ActiveWinClass("Chrome_WidgetWin_1", "C:\portable\TOOL\Chromium\chrome.exe")
;ActiveWinClass("Chrome_WidgetWin_1", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
return
} ; V1toV2: Added closing brace for [#+c]

#m::
{ ; V1toV2: Added opening brace for [#m]
global ; V1toV2: Made function global
ActiveWinClass("HwndWrapper[DefaultDomain;;fe61d881-aab5-46f3-82c9-e6b85f294cf4]", "devenv.exe")
return
} ; V1toV2: Added closing brace for [#m]

#z::
{ ; V1toV2: Added opening brace for [#z]
global ; V1toV2: Made function global
ActivateWindowFuzzy("MINGW64", "mintty", "C:\Program Files\Git\git-bash.exe")
return
} ; V1toV2: Added closing brace for [#z]


#e::
{
ActiveWinClass("CabinetWClass", "explorer.exe", "", "")
return
}
; if ActiveWinClass("Emacs") = false
;   {
;     IfWinExist , ahk_class ahk_class mintty
;     {
;       WinActivate

;     }
;     else
;     {
;       ActiveWinClass("mintty", "D:\portable\.babun\cygwin\bin\mintty.exe")
;     }
;     ; WinWait, ahk_class mintty ;Waits until the specified window exists.
;       ;Waits until the specified window is active
;       WinWaitActive, ahk_class mintty 
;       send, emacs-w32 & {enter}
;       WinMinimize, ahk_class mintty
;   }
; return

;CapsLock::ESC
LAlt & Capslock::SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")

RShift & CapsLock::
{ ; V1toV2: Added opening brace for [RShift & CapsLock]
global ; V1toV2: Made function global
    ime_s := IME_GET()
    if (ime_s = 1) {
        SwitchIME(engCode)
    }
    else {
        SwitchIME(cnCode)
    }
    ;SwitchIME(cnCode)
    return
} ; V1toV2: Added closing brace for [RShift & CapsLock]

CapsLock::LCtrl

;-- when pressing CapsLock alone, it will activate the Escpae button
Capslock Up::
{ ; V1toV2: Added opening brace for [Capslock Up]
global ; V1toV2: Made function global
SendInput("{LControl Up}")  ;--For stability
if (A_TimeSincePriorHotkey < 150)
{
  SendInput("{Escape}")
}
Else
return
return
} ; V1toV2: Added closing brace for [Capslock Up]
; CapsLock::
; send {Escape}
; ; A: for active window
; WinGetTitle, title, A
; If title contains "nvim"
; {
;     SwitchIME(engCode)
; }
; return

<#t::
{ ; V1toV2: Added opening brace for [<#t]
global ; V1toV2: Made function global
if WinExist("Windows 任务")
WinActivate()
else 
Run("taskmgr.exe")
return 
} ; V1toV2: Added closing brace for [<#t]

<#+t::
{ ; V1toV2: Added opening brace for [<#+t]
global ; V1toV2: Made function global
Run("C:\portable\ProcessExplorer\procexp.exe")
return
} ; V1toV2: Added closing brace for [<#+t]

<#q:: !F4 ;退出
<#h::Send("{Left}")
<#j::Send("{Down}")
<#k::Send("{Up}")
<#;::Send("{Right}")
; <#a::Send {Home}
; <#+P::Send ^{Home}
; #Capslock::Send {Enter}

; ;选择一行 
; <#space::
; Send {Home}
; Send +{End}
; return

#?::Run("calc.exe")
return 

<#space::
{ ; V1toV2: Added opening brace for [<#space]
global ; V1toV2: Made function global
if WinExist("ahk_exe wps.exe")
    {
    if WinActive()
        {
        WinMinimize("ahk_exe wps.exe")
        }
    else
    {
        WinActivate()
    }
    return
}
return
} ; V1toV2: Added closing brace for [<#space]


<#F11::
{ ; V1toV2: Added opening brace for [<#F11]
global ; V1toV2: Made function global
ActiveWinClass("SUMATRA_PDF_FRAME", "C:\portable\SumatraPDF\SumatraPDF.exe")
return
} ; V1toV2: Added closing brace for [<#F11]

; <#n::
; ActiveWinClass("TNavicatMainForm", "C:\Program Files\PremiumSoft\Navicat Premium\navicat.exe")
; return


<#+w::
{ ; V1toV2: Added opening brace for [<#+w]
global ; V1toV2: Made function global
Run("shell:RecycleBinFolder")
return
} ; V1toV2: Added closing brace for [<#+w]

;<#+p::
;Run shutdown -s -t 0
;return

; <#+w::
; ; run network explorer
; Run explorer.exe ::{208D2C60-3AEA-1069-A2D7-08002B30309D}
; return

#+e::
{ ; V1toV2: Added opening brace for [#+e]
global ; V1toV2: Made function global
MyClip := ClipboardAll()
;clipboard =
Send("^c")
Errorlevel := !ClipWait(2)
if ErrorLevel  ; ClipWait timed out.
    return
else{
    A_Clipboard := A_Clipboard
    Run("http://www.baidu.com/s?wd=" A_Clipboard)
}
A_Clipboard := MyClip
return
} ; V1toV2: Added closing brace for [#+e]

#b::
{ ; V1toV2: Added opening brace for [#b]
global ; V1toV2: Made function global
MyClip := ClipboardAll()
;clipboard =
Send("^c")
Errorlevel := !ClipWait(2)
if ErrorLevel  ; ClipWait timed out.
    return
else{
    A_Clipboard := A_Clipboard
    If RegExMatch(A_Clipboard, "^(https?://|www\.)[a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9_\-]{1,}[:\d]{0,5}(/\S*)?$"){
        Run(A_Clipboard)
    }
    Else{
        Run("http://www.baidu.com/s?wd=" A_Clipboard)
    }
}
A_Clipboard := MyClip
return
} ; V1toV2: Added closing brace for [#b]


#y::
{ ; V1toV2: Added opening brace for [#y]
global ; V1toV2: Made function global
MyClip := ClipboardAll()
;clipboard =
Send("^c")
Errorlevel := !ClipWait(2)
if ErrorLevel  ; ClipWait timed out.
    return
else{
    A_Clipboard := A_Clipboard
    If RegExMatch(A_Clipboard, "^(https?://|www\.)[a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9_\-]{1,}[:\d]{0,5}(/\S*)?$"){
        Run(A_Clipboard)
    }
    Else{
        Run("http://www.yandex.com/search/?text=" A_Clipboard)
    }
}
A_Clipboard := MyClip
return
} ; V1toV2: Added closing brace for [#y]

#g::
{ ; V1toV2: Added opening brace for [#g]
global ; V1toV2: Made function global
MyClip := ClipboardAll()
;clipboard =
Send("^c")
Errorlevel := !ClipWait(2)
if ErrorLevel  ; ClipWait timed out.
    return
else{
    A_Clipboard := A_Clipboard
    If RegExMatch(A_Clipboard, "^(https?://|www\.)[a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9_\-]{1,}[:\d]{0,5}(/\S*)?$"){
        Run(A_Clipboard)
    }
    Else{
        Run("https://www.google.com.hk/search?hl=en&newwindow=1&safe=strict&tbo=d&site=&source=hp&q=" A_Clipboard "&btnG=Search")
    }
}
A_Clipboard := MyClip
return
} ; V1toV2: Added closing brace for [#g]

; #n::
; ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers4", "C:\Users\ab\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; return

#c::
{ ; V1toV2: Added opening brace for [#c]
global ; V1toV2: Made function global
ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers5", "chrome.exe")
; ActivateWindowFuzzy("Testsdn", "Chrome_WidgetWin_1", "chrome.exe")
return
} ; V1toV2: Added closing brace for [#c]


#+x::
{ ; V1toV2: Added opening brace for [#+x]
global ; V1toV2: Made function global
ActiveWinClass("XLMAIN", "EXCEL.EXE")
; ActivateWindowFuzzy("ab2", "mintty", "C:\Apps\cygwin\bin\mintty.exe")
return
} ; V1toV2: Added closing brace for [#+x]

~LButton & MButton::
{ ; V1toV2: Added opening brace for [~LButton & MButton]
global ; V1toV2: Made function global
;
Send("^{End}")
;MsgBox You Pressed the Middle Button on your mouse.
return
} ; V1toV2: Added closing brace for [~LButton & MButton]

~LButton & RButton::
{ ; V1toV2: Added opening brace for [~LButton & RButton]
global ; V1toV2: Made function global
Send("^w")
return
} ; V1toV2: Added closing brace for [~LButton & RButton]

;The tilde ~ prefix makes a hotkey keep its original function
; ~*q::
; 	SendEvent, {click}
; 	return

#+v::
{ ; V1toV2: Added opening brace for [#+v]
global ; V1toV2: Made function global
cliptext := A_Clipboard
SendInput(cliptext " {Enter}")
return
} ; V1toV2: Added closing brace for [#+v]

#[::
{
global ; V1toV2: Made function global
ActivateChromeTab("Testsdn")
return
}


; Reload the script
#{::
{
scriptPath :="C:\dotfiles\AHK\start.ahk"
Reload()
}
