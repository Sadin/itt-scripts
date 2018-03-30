'************************************************
' Pin and unpin shortcuts to Windows 7/8 Taskbar
' ~DosProbie - 07.15.13
' Pin.vbs
'************************************************
' ### NOTES
' *** Usage - Pin.vbs
' *** WScript.exe "%~dp0\%~dp0\Pin.vbs" [drive:][path]filename [Argument]
' *** [Arguments] = 0 1 2
' *** 0 = Unpin from Taskbar
' *** 1 = Pin to Taskbar
' *** 2 = Install

 Set objShell = CreateObject("Shell.Application")
 Set filesystem = CreateObject("scripting.Filesystemobject")
 If filesystem.FileExists(Wscript.Arguments(0)) Then
  Set objFolder = objShell.Namespace(filesystem.GetParentFolderName(Wscript.Arguments(0)))
  Set objFolderItem = objFolder.ParseName(filesystem.GetFileName(WScript.Arguments(0)))
  Set colVerbs = objFolderItem.Verbs
  
  Select case WScript.Arguments(1)
   case 0
    For Each objVerb in colVerbs
     If Replace(objVerb.name, "&", "") = "Unpin from Taskbar" Then objVerb.DoIt
    Next
   case 1
    For Each objVerb in colVerbs
     If Replace(objVerb.name, "&", "") = "Pin to Taskbar" Then objVerb.DoIt
    Next
   case 2
    For Each objVerb in colVerbs
     If Replace(objVerb.name, "&", "") = "Install" Then objVerb.DoIt
    Next
  End Select
 End If
