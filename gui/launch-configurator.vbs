Set shell = CreateObject("WScript.Shell")
scriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ps1Path = scriptDir & "\FeishuRemoteConfigurator.ps1"
shell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & ps1Path & """", 1, False
