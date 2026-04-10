; function
; if ActiveWinClass("classFoxitReader") = true
;   msgBox "t"
; else
;   msgBox "s"

ActiveWinClass(p_class_name, p_run_path:="0", p_param:="0", p_title:="")
{
    ; Modified for fuzzy matching on p_class_name:
    ;   - Uses substring match (InStr, case-insensitive) on the window's class name.
    ;   - This replaces the exact "ahk_class" match while preserving the original p_title behaviour.
    ;   - If p_title is supplied, only windows whose title matches (according to current SetTitleMatchMode) are considered.
    ;   - If p_title is blank, all visible top-level windows are scanned.
    ;   - First matching window (in Z-order) is used.

    ; Find matching window with fuzzy class name
    if (p_title = "")
        winList := WinGetList()
    else
        winList := WinGetList(p_title)

    matchingHwnd := 0
    for hwnd in winList
    {
        class := WinGetClass(hwnd)
        if (InStr(class, p_class_name))  ; Fuzzy: class contains p_class_name (case-insensitive)
        {
            matchingHwnd := hwnd
            break
        }
    }

    if (matchingHwnd)
    {
        if WinActive(matchingHwnd)
        {
            ; put focus onto another window
            Send("{ALT DOWN}{TAB}{ALT UP}")
            if (p_class_name != "mintty")
            {
                ; there seems to be some issue with minimize x window
                WinMinimize(matchingHwnd)
            }
        }
        else
        {
            WinActivate(matchingHwnd)
        }
        return true
    }
    else
    {
        if (p_run_path != 0)
        {
            if (p_param != 0)
            {
                Run(p_run_path " -search " A_Clipboard)
            }
            else
            {
                Run(p_run_path, , , &procId)
                ; https://www.autohotkey.com/boards/viewtopic.php?t=84903
                ; workaround to activate application after launching it
                ErrorLevel := !WinWait("ahk_pid " procId, , 30)
                if ErrorLevel
                {
                    ;msgbox, 0x0,, 824E no window after 30 seconds. Aborting ...
                    return
                }
                WinActivate("ahk_pid " procId)
            }
            return true
        }
        else
            return false
    }
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
; V1toV2: Removed     SetFormat, Integer, H
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


ActivateWindowFuzzy(title, targetClass := "", executablePath := "", parameter := "")
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
