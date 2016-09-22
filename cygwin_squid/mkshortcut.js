
args = WScript.Arguments;

target = args(0);
shortcut = args(1);
//WScript.Echo("target: " + target);
//WScript.Echo("shortcut: " + shortcut);

shell = WScript.CreateObject("WScript.Shell");

link = shell.CreateShortcut(shortcut + ".lnk");

link.TargetPath = target;
//link.WorkingDirectory = "";
//link.WindowStyle = 1;
link.Save();
