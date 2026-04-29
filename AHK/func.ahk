; function
; if ActiveWinClass("classFoxitReader") = true
;   msgBox "t"
; else
;   msgBox "s"


; Find matching window with fuzzy class name

;   - Uses substring match (InStr, case-insensitive) on the window's class name.
;   - This replaces the exact "ahk_class" match while preserving the original p_title behaviour.
;   - If p_title is supplied, only windows whose title matches (according to current SetTitleMatchMode) are considered.
;   - If p_title is blank, all visible top-level windows are scanned.
;   - First matching window (in Z-order) is used.
; old versioin do not support mouse curosr moving
; ActiveWinClass(p_class_name, p_run_path := "", p_param := "", p_title := "")
; {
;     ; Get candidate windows
;     winList := (p_title = "") ? WinGetList() : WinGetList(p_title)

;     matchingHwnd := 0

;     for hwnd in winList
;     {
;         class := WinGetClass("ahk_id " hwnd)

;         ; fuzzy match (case-insensitive)
;         if InStr(class, p_class_name)
;         {
;             matchingHwnd := hwnd
;             break
;         }
;     }

;     if matchingHwnd
;     {
;         winId := "ahk_id " matchingHwnd

;         if WinActive(winId)
;         {
;             ; switch away first (avoid weird focus issues)
;             Send("!{Tab}")

;             if (p_class_name != "mintty")
;                 WinMinimize(winId)
;         }
;         else
;         {
;             WinActivate(winId)
;         }

;         return matchingHwnd
;     }

;     ; --- No window found → launch app ---
;     if (p_run_path != "")
;     {
;         cmd := p_run_path

;         if (p_param != "")
;             cmd .= " " p_param

;         Run(cmd, , , &pid)

;         ; wait for window
;         if !WinWait("ahk_pid " pid, , 30)
;             return 0

;         WinActivate("ahk_pid " pid)

;         return WinExist("ahk_pid " pid)
;     }

;     return 0
; }

; position the cursor to the center of newly activated windows.
; DPI awareness + consistent screen coordinates, then move the cursor after activation.
ActiveWinClass(p_class_name, p_run_path := "", p_param := "", p_title := "")
{
    ; 🔑 Fix DPI scaling issues (multi-monitor safe)
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3)
    CoordMode "Mouse", "Screen"

    ; Get candidate windows
    winList := (p_title = "") ? WinGetList() : WinGetList(p_title)

    matchingHwnd := 0

    for hwnd in winList
    {
        class := WinGetClass("ahk_id " hwnd)

        ; fuzzy match (case-insensitive)
        if InStr(class, p_class_name)
        {
            matchingHwnd := hwnd
            break
        }
    }

    if matchingHwnd
    {
        winId := "ahk_id " matchingHwnd

        if WinActive(winId)
        {
            ; switch away first
            Send("!{Tab}")

            if (p_class_name != "mintty")
                WinMinimize(winId)

            return matchingHwnd
        }
        else
        {
            WinActivate(winId)
            WinWaitActive(winId)
        }

        ; 🎯 move cursor to window center
        WinGetPos(&x, &y, &w, &h, winId)

        centerX := x + w // 2
        centerY := y + h // 2

        MouseMove(centerX, centerY, 0)

        return matchingHwnd
    }

    ; --- No window found → launch app ---
    if (p_run_path != "")
    {
        cmd := p_run_path

        if (p_param != "")
            cmd .= " " p_param

        Run(cmd, , , &pid)

        ; wait for window
        if !WinWait("ahk_pid " pid, , 30)
            return 0

        WinActivate("ahk_pid " pid)
        WinWaitActive("ahk_pid " pid)

        hwnd := WinExist("ahk_pid " pid)

        ; 🎯 move cursor to new window center
        WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)

        centerX := x + w // 2
        centerY := y + h // 2

        MouseMove(centerX, centerY, 0)

        return hwnd
    }

    return 0
}

ActiveGrpWinClass(p_class_name, p_grp_name, p_run_path)
{
; IfWinNotExist, ahk_class %p_class_name%
if !WinExist("ahk_exe " p_run_path)
    Run(p_run_path)
; GroupAdd, %p_grp_name%, ahk_class %p_class_name%
GroupAdd(p_grp_name, "ahk_exe " p_run_path)
;if WinActive("ahk_exe %p_run_path%") ; wrong
;if WinActivate ahk_exe winword.exe; wrong
; WinAcitvate ~ is not a command nor function, should be change to
if WinActive("ahk_exe " p_run_path)
{
    GroupActivate(p_grp_name, "r")
}
else
{
    ; WinActivate ahk_class %p_class_name%
    WinActivate("ahk_exe " p_run_path)
}
return
}


; Function to Toggle or Run application
ToggleOrRun(winClass, winExe, runPath) {
    ; Combine criteria for precise matching
    winTitle := winClass " " winExe

    if WinExist(winTitle) {
        if WinActive(winTitle) {
            WinMinimize(winTitle)
        } else {
            WinActivate(winTitle)
        }
    } else {
        Run(runPath)
    }
}

SwitchIME(dwLayout){
    HKL:=DllCall("LoadKeyboardLayout", "Str", dwLayout, "UInt", 1)
    ctl := ControlGetClassNN(ControlGetFocus("A"))
    ErrorLevel := SendMessage(0x50, 0, HKL, ctl, "A")
}


    ; HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\
    engCode := 0x4090409
    ; cn Code is different for what return from GetKeyboardLayout (0x8040804)
    ; I don't know why
    cnCode := 00000804

; a: array contain texts to be sended
SendInputArray(a, t:=90) {

    engCode := 0x4090409
    ; cnCode should be put inside this function. otherwise  SwitchIME(cnCode) will not work
    cnCode := 00000804

    SwitchIME(engCode)
    ; get current keyboard layout

    WinID := WinGetID("A")
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")

    ; switch to english input temporarily
    SwitchIME(engCode)

    ; By preceding any parameter with % , it becomes an expression.
    ; msgbox, % a[1] ", " a[2]
    ; b := a.clone()
    ; b[1] *= 3
    ; return b

    for i, text in a
    {
        SendInput(text)
        Sleep(t)
    }

    SwitchIME(cnCode)
    Return

}


IME_GET(WinTitle:="")
;-----------------------------------------------------------
; “获得 Input Method Editors 的状态”
; 1 是中文， 0 不是中文
;-----------------------------------------------------------
{
    if (WinTitle = "")
        WinTitle := "A"
    hWnd := WinGetID(WinTitle)
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")

    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows(true)
    ErrorLevel := SendMessage(0x283, 0x005, 0, , "ahk_id " DefaultIMEWnd)
    DetectHiddenWindows(DetectSave)
    Return ErrorLevel
}


ActivateWindowFuzzyTitle(title, targetClass := "", executablePath := "", parameter := "")
{
  activeWindow := WinGetID("A")

  owindowList := WinGetList(,,,)
  awindowList := Array()
  windowList := owindowList.Length
  For v in owindowList
  {   awindowList.Push(v)
  }

  Loop awindowList.Length
  {
    thisTitle := ""
    thisClass := ""
    thisTitle := WinGetTitle("ahk_id " awindowList[A_Index])
    thisClass := WinGetClass("ahk_id " awindowList[A_Index])

    if (RegExMatch(thisTitle, "i)" . title) && (targetClass = "" || thisClass = targetClass))
    {
      if (awindowList[A_Index] = activeWindow) && (targetClass != "mintty")
      {
        WinMinimize("ahk_id " awindowList[A_Index])
      }
      else
      {
        WinActivate("ahk_id " awindowList[A_Index])
      }
      return
    }
  }

  if (executablePath != "")
  {
    Run(executablePath " " parameter)
  }
}

ActivateChromeTab(tabTitle)
{
  ; Activate Chrome window
  WinActivate("ahk_class Chrome_WidgetWin_1")

  ; Wait for Chrome to become the active window
  WinWaitActive("ahk_class Chrome_WidgetWin_1")

  ; Get the title of the current tab
  currentTitle := WinGetTitle("ahk_class Chrome_WidgetWin_1")

  ; Check if the current tab's title already contains the desired text
  if (InStr(currentTitle, tabTitle) > 0)
  {
    ; The desired tab is already active, exit the function
    return
  }

  ; Send Ctrl+1 to switch to the first tab
  SendInput("^1")

  ; Wait for the tab to load
  Sleep(50)

  ; Send Ctrl+Tab to cycle through the tabs until the desired tab is found
  Loop
  {
    ; Get the title of the current tab
    currentTitle := WinGetTitle("ahk_class Chrome_WidgetWin_1")

    ; Check if the current tab's title matches the desired title
    if (InStr(currentTitle, tabTitle) > 0)
    {
      ; The desired tab is found, exit the loop
      break
    }

    ; Send Ctrl+Tab to switch to the next tab
    SendInput("^{Tab}")

    ; Wait for the tab to load
    Sleep(50)
  }
}

; Mode 1: A window's title or class must START with the specified string.
; This is perfect for "HwndWrapper" prefix matching.
SetTitleMatchMode 1
; support cycling through multiple instances
ToggleOrRunx(classPrefix, winExe, runPath)
{
    static lastIndex := 0

    ; 🔑 make coordinates consistent (PER_MONITOR_AWARE_V2)
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3)

    CoordMode "Mouse", "Screen"

    winList := []

    for hwnd in WinGetList("ahk_exe " winExe)
    {
        class := WinGetClass("ahk_id " hwnd)
        if (SubStr(class, 1, StrLen(classPrefix)) = classPrefix)
        {
            winList.Push(hwnd)
        }
    }

    if (winList.Length = 0)
    {
        Run(runPath)
        return
    }

    ; cycle
    lastIndex++
    if (lastIndex > winList.Length)
        lastIndex := 1

    hwnd := winList[lastIndex]

    WinActivate("ahk_id " hwnd)
    WinWaitActive("ahk_id " hwnd)

    ; get window rect (now DPI-correct)
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)

    centerX := x + w // 2
    centerY := y + h // 2

    MouseMove(centerX, centerY, 0)
}
; ToggleOrRunx(classPrefix, winExe, runPath)
; {
;     winList := WinGetList("ahk_exe " winExe)

;     for hwnd in winList
;     {
;         class := WinGetClass("ahk_id " hwnd)
;         ; MsgBox class

;         if (SubStr(class, 1, StrLen(classPrefix)) = classPrefix)
;         {
;             if WinActive("ahk_id " hwnd)
;             {
;                 WinMinimize("ahk_id " hwnd)
;             }
;             else
;             {
;                 WinActivate("ahk_id " hwnd)
;             }
;             return
;         }
;     }

;     ; no matching window found → run program
;     Run(runPath)
; }

#Requires AutoHotkey v2.0
DllCall("SetThreadDpiAwarenessContext", "ptr", -3)

!m:: {
    CoordMode "Mouse", "Screen"

    ; 1. Get current mouse position
    MouseGetPos(&mouseX, &mouseY)

    ; 2. Find which monitor the mouse is on
    currentMon := 0
    monCount := MonitorGetCount()

    Loop monCount {
        MonitorGet(A_Index, &L, &T, &R, &B)
        if (mouseX >= L && mouseX <= R && mouseY >= T && mouseY <= B) {
            currentMon := A_Index
            break
        }
    }

    ; If for some reason the monitor isn't found, default to 1
    if (currentMon == 0)
        currentMon := 1

    ; 3. Identify the target monitor (Toggles between 1 and 2)
    targetMon := (currentMon == 1) ? 2 : 1

    ; 4. Use WorkArea instead of MonitorGet to avoid the Taskbar
    MonitorGetWorkArea(targetMon, &Left, &Top, &Right, &Bottom)

    ; 5. Calculate Center
    centerX := Left + (Right - Left) / 2
    centerY := Top + (Bottom - Top) / 2

    ; 6. Move Mouse instantly
    MouseMove(centerX, centerY, 0)
}
