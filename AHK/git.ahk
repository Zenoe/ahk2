#Requires AutoHotkey v2.0

; Hotkey: Ctrl + Alt + G (Change as desired)
<#w:: {
    path := GetExplorerPath()
    if (path) {
        ; Launch Git Bash in the retrieved directory
        ;Run('C:\Program Files\Git\git-bash.exe', path)

        Run('"C:\Program Files\Git\git-bash.exe"', path, , &gitBashPid)
        ; Wait for the window to exist using the PID, then activate it
        ; wait  3secs for that specific process window to appear
        if WinWait("ahk_pid " gitBashPid, , 3) {
            WinActivate("ahk_pid " gitBashPid)
        }

    }
}

GetExplorerPath() {
    hwnd := WinActive("ahk_class CabinetWClass")
    if !hwnd
        return ""

    ; In Windows 11, the active tab's control is always 'ShellTabWindowClass1'
    try
        activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd)
    catch
        activeTab := 0 ; Fallback for older Windows without tabs

    for window in ComObject("Shell.Application").Windows {
        if (window.hwnd != hwnd)
            continue

        if (activeTab) {
            ; Use IShellBrowser to verify this specific window object matches the active tab's HWND
            static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
            shellBrowser := ComObjQuery(window, IID_IShellBrowser, IID_IShellBrowser)
            ComCall(3, shellBrowser, "uint*", &thisTab := 0) ; GetWindow method
            if (thisTab != activeTab)
                continue
        }

        ; Return the folder path of the matched tab
        return window.Document.Folder.Self.Path
    }
    return ""
}

