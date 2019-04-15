[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Setup]
AppName=WEET
AppVerName=WEET - 1.0.0
AppVersion=1.0.0
DefaultDirName={pf}\WEET
DefaultGroupName=WEET
VersionInfoCompany=WEET
VersionInfoCopyright=Copyright © 2017. All rights reserved.
VersionInfoDescription=WEET
VersionInfoVersion=1.0.0
UninstallDisplayIcon={app}\weet.exe
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
OutputDir=.
ChangesAssociations=yes
ChangesEnvironment=yes
UsePreviousAppDir=no
UsePreviousGroup=no

[Registry]
Root:HKCR; Subkey: "weet"; ValueType: string; ValueData: "URL:Custom Protocol"; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weet"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weet\DefaultIcon"; ValueType: string; ValueData: "{app}\weet.exe,0"; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weet\shell\open\command"; ValueType: string; ValueData: """{app}\weet.exe"" ""%1"""; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weets"; ValueType: string; ValueData: "URL:Custom Protocol"; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weets"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weets\DefaultIcon"; ValueType: string; ValueData: "{app}\weet.exe,0"; Flags: uninsdeletekey;
Root:HKCR; Subkey: "weets\shell\open\command"; ValueType: string; ValueData: """{app}\weet.exe"" ""%1"""; Flags: uninsdeletekey;

[Files]
Source: ".\clscan.exe"; DestDir: "{app}";
Source: ".\clscan.license"; DestDir: "{app}";
Source: ".\weet.exe"; DestDir: "{app}";

[CODE]
Function IsSuppressMsgBoxes() : boolean;
var
	i : integer;
begin
	for i := 1 to ParamCount() do
		result := result or (UpperCase(ParamStr(i)) = '/SUPPRESSMSGBOXES') or (UpperCase(ParamStr(i)) = '/SILENT') or (UpperCase(ParamStr(i)) = '/VERYSILENT')
end;

Function IsSuppressUninstall() : boolean;
var
	i : integer;
begin
	for i := 1 to ParamCount() do
		result := result or (UpperCase(ParamStr(i)) = '/SUPPRESSUNINSTALL')
end;

Function SuppressableMsgBox(const Text: String; const Typ: TMsgBoxType; const Buttons: Integer): Integer;
begin
	if(not isSuppressMsgBoxes()) then
		result := MsgBox(Text,Typ,Buttons);
end;

Procedure RemoveSearchPath();
var
	path,
	txt : String;
	p : Integer;
begin
	path := ExpandConstant(';{app}');
	
	if RegQueryStringValue(HKLM,'SYSTEM\CurrentControlSet\Control\Session Manager\Environment','Path',txt) then
	begin
		p := pos(path,txt);
		
		if p <> 0 then
		begin
			delete(txt,p,length(path));
			
			if copy(txt,length(txt),1) = ';' then
        txt := copy(txt,1,length(txt) - 1);
			
			RegWriteStringValue(HKLM,'SYSTEM\CurrentControlSet\Control\Session Manager\Environment','Path',txt);
		end;
	end;
end;

Function Uninstall(title : String) : Boolean;
var
	cmd : String;
	ErrorCode : Integer;
begin
	if IsWin64 then
	begin
		result := not RegQueryStringValue(HKLM,'Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' + title + '_is1','UninstallString',cmd);

		if not result then
		begin
			result := ShellExec('', cmd,'/VERYSILENT', '', SW_SHOWMINIMIZED, ewWaitUntilTerminated, ErrorCode);
			if not result then
				SuppressableMsgBox('Uninstall of ' + title + ' terminated with error code : ' + IntToStr(ErrorCode) + chr(10) + SysErrorMessage(ErrorCode),mbError,MB_OK);
		end;
	end
	else
	begin
		result := not RegQueryStringValue(HKLM,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + title + '_is1','UninstallString',cmd);

		if not result then
		begin
			result := ShellExec('', cmd,'/VERYSILENT', '', SW_SHOWMINIMIZED, ewWaitUntilTerminated, ErrorCode);
			if not result then
				SuppressableMsgBox('Uninstall of ' + title + ' terminated with error code : ' + IntToStr(ErrorCode) + chr(10) + SysErrorMessage(ErrorCode),mbError,MB_OK);
		end;
	end;
end;

Function NextButtonClick(CurPageID: Integer): Boolean;
var 
	ErrorCode : integer;
	dotnet : String;
begin
	result := true;
	
	if (CurPageId = wpReady) then
	begin
		if(not IsSuppressUninstall) then
		begin
			result := Uninstall('WEET');
		end;
	end;
end;

Procedure CurStepChanged(CurStep: TSetupStep);
Var
	ErrorCode : integer;
	dotnet : String;
begin
	if (CurStep=ssPostInstall) then 
	begin
	end;
end;

procedure CurUninstallStepChanged(CurrentStep: TUninstallStep);

begin
 if CurrentStep = usUninstall then
	 RemoveSearchPath();
end; 
