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
<#+o:: Run("`"notepad`"")

<#f:: ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe")
<#+f:: ActiveWinClass("EVERYTHING", "C:\Program Files\Everything\Everything.exe", "Clipboard")

<#+s:: Run("regedit.exe")

#n::ToggleOrRunx("HwndWrapper", "devenv.exe", "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")

#+c:: ActiveWinClass("Chrome_WidgetWin_1", "C:\Program Files\Google\Chrome\Application\chrome.exe")

; #n::

#x:: ActivateWindowFuzzyTitle("MINGW64", "mintty", "C:\Program Files\Git\git-bash.exe")

#e:: ActiveWinClass("CabinetWClass", "explorer.exe", "", "")

; #n::
; {
; global
; ActiveWinClass("HwndWrapper[DefaultDomain;;78a7241c-694f-4bf4-9937-12bde4b0ab5c]", "devenv.exe")
; return
; }


#m::
{
ActiveWinClass("HwndWrapper[DefaultDomain", "devenv.exe")
return
}


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
{
global ; V1toV2: Made function global
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
{ ; V1toV2: Added opening brace for [<#F11]
global ; V1toV2: Made function global
ActiveWinClass("SUMATRA_PDF_FRAME", "C:\portable\SumatraPDF\SumatraPDF.exe")
return
} ; V1toV2: Added closing brace for [<#F11]


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
}

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
{
ToggleOrRun("ahk_class Chrome_WidgetWin_1", "ahk_exe chrome.exe", "chrome.exe")
;ActiveGrpWinClass("Chrome_WidgetWin_1", "kjexplorers5", "C:\Program Files\Google\Chrome\Application\chrome.exe")
return
}


#+x::
{
ActiveWinClass("XLMAIN", "EXCEL.EXE")
; ActivateWindowFuzzyTitle("ab2", "mintty", "C:\Apps\cygwin\bin\mintty.exe")
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
global ; V1toV2: Made function global
cliptext := A_Clipboard
SendInput(cliptext " {Enter}")
return
}

#[:: ActivateChromeTab("DeepSeek")


; Reload the script
#{::
{
scriptPath :="C:\dotfiles\AHK\start.ahk"
Reload()
}

SetPinyinToEnglishMode(hwnd := 0)
{
    if (hwnd = 0)
        hwnd := WinExist("A")

    ; 关键修正：必须加上 imm32\ 前缀 + 正确的返回类型
    hIMC := DllCall("imm32\ImmGetContext", "Ptr", hwnd, "Ptr")

    if (hIMC)
    {
        ; IME_CMODE_ALPHANUMERIC = 0  → 强制进入英文模式
        DllCall("imm32\ImmSetConversionStatus", "Ptr", hIMC, "UInt", 0, "UInt", 0)

        ; 释放上下文
        DllCall("imm32\ImmReleaseContext", "Ptr", hwnd, "Ptr", hIMC)
    }

    Sleep(50)   ; 给微软拼音一点反应时间
}


; =============================================================
; Updated ActiveWinClass - now RETURNS the hwnd on success (instead of just true/false)
; This lets us target the exact window when switching IME
; =============================================================

<#z::
{
;; need to switch to english 'cause win11's bug: always switch to chinese when activate emacs
    hwnd := ActiveWinClass("Emacs", "C:\emacs\bin\runemacs.exe")

    ; Switch Microsoft Pinyin → English (US) on the exact Emacs window
     if (hwnd)
    ;     SetPinyinToEnglishMode(hwnd)

    return
}
