#Include "c:/dotfiles/AHK/func.ahk"

SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

#SingleInstance Force
SetTitleMatchMode(2)
;DetectHiddenWindows, on


#i::Run("`"C:\Windows\system32\rundll32.exe`" sysdm.cpl,EditEnvironmentVariables")

#+i::Run("`"C:\WINDOWS\system32\rundll32.exe`" shell32.dll,Control_RunDLL sysdm.cpl")

; <#v:: ActiveWinClass("MozillaWindowClass", "C:\Program Files\Mozilla Firefox\firefox.exe")

<#o:: ActiveWinClass("Notepad", "Notepad")
<#+o:: {
    Run "notepad.exe"
    ; ;  Wait for it to be ready
    ; if WinWaitActive("ahk_class Notepad", , 3) {
    ;     ; 3. Only attempt to paste if the clipboard has content
    ;     if (A_Clipboard != "") {
    ;         Send "^v"
    ;     }
    ; }

}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; not deal with multi-tab explorer in win11
; #HotIf WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
; <#+o::
; {
;     for window in ComObject("Shell.Application").Windows
;     {
;         if (window.hwnd == WinActive("A"))
;         {
;             for item in window.Document.SelectedItems
;             {
;                 Run("notepad.exe " . '"' . item.Path . '"')
;                 return ; Opens only the first selected file
;             }
;         }
;     }
; }
; #HotIf


;ClipWait: Pauses the script until the clipboard contains data, preventing the script from trying to open an empty path.
;#HotIf: Ensures the hotkey only works when a Windows Explorer window is active.
; Hotkey: Press F1 while Explorer is active
#HotIf WinActive("ahk_class CabinetWClass")
<#e:: {
    try {
        selectedFiles := GetExplorerSelection()
        if (selectedFiles.Length > 0) {
            ; Open the first selected file with Notepad
            Run('notepad.exe "' selectedFiles[1] '"')
        }
    } catch Error as err {
        MsgBox("Error: " err.Message)
    }
}
#HotIf

; get current selected file of current tab of explorer
GetExplorerSelection() {
    hwnd := WinExist("A")
    activeTab := 0

    ; Windows 11 Tab Support: Identify the specific active tab handle
    try activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd)

    selectedPaths := []
    shellWindows := ComObject("Shell.Application").Windows

    for window in shellWindows {
        ; Ensure we are looking at the correct Explorer window
        if (window.hwnd != hwnd)
            continue

        ; If tabs exist, ensure we only pull from the visible/active tab
        if (activeTab != 0) {
            static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
            shellBrowser := ComObjQuery(window, IID_IShellBrowser, IID_IShellBrowser)
            ComCall(3, shellBrowser, "uint*", &thisTab := 0) ; GetWindow call
            if (thisTab != activeTab)
                continue
        }

        ; Retrieve paths of all selected items in this tab
        for item in window.Document.SelectedItems {
            selectedPaths.Push(item.Path)
        }
        break
    }
    return selectedPaths
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#b::{
ToggleOrRunx("TscShellContainerClass", "mstsc.exe", "C:\Windows\System32\mstsc.exe")
}
<#f::{
ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe")
return
}
; <#+f:: ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe", "Clipboard")
<#+f::{
 ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe", '-s "' A_Clipboard '"')
 return
}

<#+s:: Run("regedit.exe")

;#n::ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers4", "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")
#n::ToggleOrRunx("HwndWrapper", "devenv.exe", "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")

#+x:: ActivateWindowFuzzyTitle("MINGW64", "mintty", "C:\Program Files\Git\git-bash.exe")

;CapsLock::ESC
LAlt & Capslock::SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")

RShift & CapsLock::
{
global
    ime_s := IME_GET()
    if (ime_s = 1) {
        SwitchIME(engCode)
    }
    else {
        SwitchIME(cnCode)
    }
    ;SwitchIME(cnCode)
    return
}

CapsLock::LCtrl

;-- when pressing CapsLock alone, it will activate the Escpae button
Capslock Up::
{
global
SendInput("{LControl Up}")  ;--For stability
if (A_TimeSincePriorHotkey < 150)
{
  SendInput("{Escape}")
}
Else
return
return
}
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
{
global
if WinExist("Windows 任务")
WinActivate()
else 
Run("taskmgr.exe")
return 
}

<#+t::
{
Run("C:\portable\ProcessExplorer\procexp.exe")
return
}

; middle mouse key -->copy
; clears the clipboard first to ensure you are copying new text
MButton:: {
    A_Clipboard := "" ; Clear clipboard
    Send("^c")        ; Send copy
    if !ClipWait(0.5) ; Wait to ensure text was copied
        ToolTip("No text selected!")
    SetTimer () => ToolTip(), -2000
}
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


<#F11::
{
global
ActiveWinClass("SUMATRA_PDF_FRAME", "C:\portable\SumatraPDF\SumatraPDF.exe")
return
}


<#+w:: Run("shell:RecycleBinFolder")

;<#+p::
;Run shutdown -s -t 0
;return

; <#+w::
; ; run network explorer
; Run explorer.exe ::{208D2C60-3AEA-1069-A2D7-08002B30309D}
; return

#+b::
{
global
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
}


#!b::
{
global
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
}


#y::
{
global
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
}

#g::
{
global
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
}

; #n::
; ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers4", "C:\Users\ab\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; return

#c::
{
ToggleOrRunx("Chrome_WidgetWin_1", "chrome.exe", "chrome.exe")
;ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers5", "C:\Program Files\Google\Chrome\Application\chrome.exe")
return
}


#x::
{
;ActiveWinClass("mintty", "C:\Users\2004l\Desktop\Cygwin64 Terminal.lnk")
ToggleOrRunxWithTitleNot("mintty", "mintty.exe", "C:\Users\2004l\Desktop\Cygwin64 Terminal.lnk", "MINGW64")
return
}

^!z:: {
ToggleOrRunxWithTitle("Chrome_WidgetWin_1", "ChatGPT.exe", "ChatGPT.exe", "ChatGPT")
return
}

#v::
{
ToggleOrRunxWithTitle("mintty", "mintty.exe", "C:\Program Files\Git\git-bash.exe", "MINGW64")
;ActivateWindowFuzzyTitle("MINGW64", "mintty", "C:\Program Files\Git\git-bash.exe")
return
}
~LButton & MButton::Send("^{End}")
; Hold Left Mouse Button, then press Right Mouse Button → send Ctrl + W
~LButton & RButton::Send("^w")

;The tilde ~ prefix makes a hotkey keep its original function
; ~*q::
; 	SendEvent, {click}
; 	return

#+v::
{
global
cliptext := A_Clipboard
SendInput(cliptext " {Enter}")
return
}

#[:: ActivateChromeTab("DeepSeek")
;#]::


; Reload the script
#{::
{
scriptPath :="C:\dotfiles\AHK\start.ahk"
Reload()
}

; =============================================================
; Updated ActiveWinClass - now RETURNS the hwnd on success (instead of just true/false)
; This lets us target the exact window when switching IME
; =============================================================

<#z::
{
    hwnd := ActiveWinClass("Emacs", "C:\emacs\bin\runemacs.exe")
    return
}

; Hotkey: Ctrl + Alt + C
^!c:: {
    targetPath := "C:\"
    found := false

    ; Iterate through all open shell windows
    for window in ComObject("Shell.Application").Windows {
        ; Check if the window is a File Explorer window (CabinetWClass)
        if (InStr(window.FullName, "explorer.exe")) {
            ; Navigate the existing window to the target path
            window.Navigate(targetPath)
            WinActivate("ahk_id " window.hwnd)
            found := true
            break
        }
    }

    ; If no explorer window was open, run a new instance
    if !found {
        Run(targetPath)
    }
}


; Hotkey: Win + Shift + Left Arrow
#+Left::MoveWindowToNextScreen()

; Hotkey: Win + Shift + Right Arrow
#+Right::MoveWindowToNextScreen()

MoveWindowToNextScreen() {
    activeHWnd := WinExist("A")
    if !activeHWnd
        return

    ; Check if the window is maximized
    wasMaximized := WinGetMinMax(activeHWnd) = 1

    ; Restore first if maximized so WinGetPos gives real coordinates
    if wasMaximized
        WinRestore(activeHWnd)

    WinGetPos(&x, &y, &w, &h, activeHWnd)

    currentMonitor := 0
    monitorCount := MonitorGetCount()
    centerX := x + (w / 2)
    centerY := y + (h / 2)

    loop monitorCount {
        MonitorGetWorkArea(A_Index, &L, &T, &R, &B)
        if (centerX >= L && centerX <= R && centerY >= T && centerY <= B) {
            currentMonitor := A_Index
            break
        }
    }

    ; Fallback: if center not found (e.g. window is off-screen), use monitor 1
    if !currentMonitor
        currentMonitor := 1

    nextMonitor := Mod(currentMonitor, monitorCount) + 1

    MonitorGetWorkArea(currentMonitor, &currL, &currT, &currR, &currB)
    MonitorGetWorkArea(nextMonitor, &nextL, &nextT, &nextR, &nextB)

    if wasMaximized {
        ; Move to top-left of next monitor's work area, then re-maximize
        WinMove(nextL, nextT, , , activeHWnd)
        WinMaximize(activeHWnd)
    } else {
        ; Preserve relative position, clamped to target monitor's work area
        newX := nextL + (x - currL)
        newY := nextT + (y - currT)
        WinMove(newX, newY, , , activeHWnd)
    }
}
!F4::{
    Send("root")
    Send("{Tab}")
    SendText("qwe123QWE")
    Send("{Enter}")
}
