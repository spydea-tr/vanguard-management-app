Set oWS = WScript.CreateObject("WScript.Shell")

' Masaüstü kısayolu
sLinkFileDesktop = oWS.ExpandEnvironmentStrings("%USERPROFILE%\Desktop\Vanguard Management App.lnk")
Set oLinkDesktop = oWS.CreateShortcut(sLinkFileDesktop)
oLinkDesktop.TargetPath = "C:\Program Files\Vanguard Management App\vanguard_management.cmd"
oLinkDesktop.WorkingDirectory = "C:\Program Files\Vanguard Management App"
oLinkDesktop.Description = "Vanguard Management App"
oLinkDesktop.IconLocation = "C:\Program Files\Vanguard Management App\app.ico"
oLinkDesktop.Save

' Başlat Menüsü kısayolu
sLinkFileStart = oWS.SpecialFolders("Programs") & "\Vanguard Management App.lnk"
Set oLinkStart = oWS.CreateShortcut(sLinkFileStart)
oLinkStart.TargetPath = "C:\Program Files\Vanguard Management App\vanguard_management.cmd"
oLinkStart.WorkingDirectory = "C:\Program Files\Vanguard Management App"
oLinkStart.Description = "Vanguard Management App"
oLinkStart.IconLocation = "C:\Program Files\Vanguard Management App\app.ico"
oLinkStart.Save

' Kendini sil
Set fso = CreateObject("Scripting.FileSystemObject")
fso.DeleteFile WScript.ScriptFullName, True
