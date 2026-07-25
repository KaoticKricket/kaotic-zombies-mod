; Kaotic Zombies Interactive Mod Installer
; Inno Setup Script for Windows

#define MyAppName "Kaotic Zombies Interactive Mod"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Kaotic Modding"
#define MyAppURL ""
#define MyAppExeName "tiktok_bridge.py"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\Call of Duty Black Ops III\mods\kaotic_zombies
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=LICENSE
OutputBaseFilename=KaoticZombiesMod-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\start_bridge.bat
PrivilegesRequired=admin
CreateAppDir=no
UsePreviousAppDir=no
DisableDirPage=no
DisableProgramGroupPage=yes
OutputDir=Output

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel2=This will install the Kaotic Zombies Interactive Mod for Black Ops 3.%n%nThe mod adds TikTok/Tikfinity integration to your Zombies gameplay.
FinishedLabel=The Kaotic Zombies Interactive Mod has been successfully installed.%n%n%nNext steps:%n1. Build the mod using BO3 Mod Tools%n2. Configure your RCON settings%n3. Start the TikTok Bridge%n4. Add your TikTok username to the creator network%n%nSee README.md for detailed instructions.

[CustomMessages]
Bo3PathTitle=Black Ops 3 Installation
Bo3PathDescription=Please select your Black Ops 3 installation directory.
Bo3PathBrowse=Browse...
Bo3PathInvalid=The specified directory does not contain a valid Black Ops 3 installation.
ConfigTitle=Configuration
ConfigDescription=Configure the TikTok Bridge settings.
RconPassword=RCON Password:
RconPort=RCON Port:
WebhookPort=Webhook Port:

[Files]
; Mod files
Source: "zm_mod\scripts\zm\kaotic_zombies.gsc"; DestDir: "{app}\zm_mod\scripts\zm"; Flags: ignoreversion
Source: "zm_mod\scripts\zm\kaotic_zombies.csc"; DestDir: "{app}\zm_mod\scripts\zm"; Flags: ignoreversion
Source: "zm_mod\mod.csv"; DestDir: "{app}\zm_mod"; Flags: ignoreversion
Source: "zm_mod\zone_source\kaotic_zombies.zone"; DestDir: "{app}\zm_mod\zone_source"; Flags: ignoreversion

; Python bridge files
Source: "tiktok_bridge.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "requirements.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "update_checker.py"; DestDir: "{app}"; Flags: ignoreversion

; Configuration templates
Source: "creator_network.json"; DestDir: "{app}"; Flags: ignoreversion

; Documentation
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "CHANGELOG.md"; DestDir: "{app}"; Flags: ignoreversion

; Batch files
Source: "start_bridge.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "manage_creators.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "manage_creators.py"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}\TikTok Bridge"; Filename: "pythonw.exe"; Parameters: """{app}\tiktok_bridge.py"""; WorkingDir: "{app}"; IconFilename: "pythonw.exe"; Comment: "Start TikTok Interactive Bridge"
Name: "{autoprograms}\{#MyAppName}\Creator Manager"; Filename: "{app}\manage_creators.bat"; WorkingDir: "{app}"; Comment: "Manage authorized creators"
Name: "{autoprograms}\{#MyAppName}\Uninstall"; Filename: "{uninstallexe}"; Comment: "Remove Kaotic Zombies Mod"
Name: "{autodesktop}\Kaotic TikTok Bridge"; Filename: "pythonw.exe"; Parameters: """{app}\tiktok_bridge.py"""; WorkingDir: "{app}"; IconFilename: "pythonw.exe"; Comment: "Start TikTok Interactive Bridge"

[Run]
Filename: "python.exe"; Parameters: "-m pip install -r ""{app}\requirements.txt"" --quiet"; WorkingDir: "{app}"; StatusMsg: "Installing Python dependencies..."; Flags: runhidden waituntilterminated
Filename: "{app}\README.md"; Description: "Open README file"; Flags: shellexec postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}\__pycache__"
Type: filesandordirs; Name: "{app}\zm_mod"

[Code]
var
  Bo3Page: TInputDirWizardPage;
  ConfigPage: TInputQueryWizardPage;

function GetBo3Path(Param: String): String;
var
  RegPath: String;
begin
  // Try to find BO3 from registry
  if RegQueryStringValue(HKLM32, 'SOFTWARE\Wow6432Node\Valve\Steam', 'InstallPath', RegPath) then
  begin
    Result := AddBackslash(RegPath) + 'steamapps\common\Call of Duty Black Ops III';
    if DirExists(Result) then
      Exit;
  end;
  
  // Try common paths
  Result := 'C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III';
  if DirExists(Result) then
    Exit;
    
  Result := 'C:\Program Files\Steam\steamapps\common\Call of Duty Black Ops III';
  if DirExists(Result) then
    Exit;
    
  // Default to Program Files
  Result := 'C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III';
end;

function IsBo3PathValid(Path: String): Boolean;
begin
  Result := DirExists(Path + '\mods') and DirExists(Path + '\bin');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  PythonPath: String;
begin
  Result := True;
  
  if CurPageID = Bo3Page.ID then
  begin
    if not IsBo3PathValid(Bo3Page.Values[0]) then
    begin
      MsgBox(ExpandConstant('{cm:Bo3PathInvalid}'), mbError, MB_OK);
      Result := False;
    end
    else
    begin
      // Set the actual installation directory based on BO3 path
      WizardForm.DirEdit.Text := Bo3Page.Values[0] + '\mods\kaotic_zombies';
    end;
  end;
  
  if CurPageID = wpReady then
  begin
    // Check if Python is installed
    PythonPath := ExpandConstant('{pf}\Python311\python.exe');
    if not FileExists(PythonPath) then
      PythonPath := ExpandConstant('{pf}\Python310\python.exe');
    if not FileExists(PythonPath) then
      PythonPath := ExpandConstant('{pf}\Python39\python.exe');
    if not FileExists(PythonPath) then
      PythonPath := ExpandConstant('{pf}\Python38\python.exe');
      
    if not FileExists(PythonPath) then
    begin
      if MsgBox('Python 3.8 or higher was not detected on your system. The installer will still proceed, but you will need to install Python manually from https://www.python.org/ before running the TikTok Bridge. Continue?', mbConfirmation, MB_YESNO) = IDNO then
        Result := False;
    end;
  end;
end;

procedure InitializeWizard;
begin
  // Create custom pages
  Bo3Page := CreateInputDirPage(wpSelectDir,
    ExpandConstant('{cm:Bo3PathTitle}'), ExpandConstant('{cm:Bo3PathDescription}'),
    'Select the folder where Black Ops 3 is installed:', False, '');
  
  Bo3Page.Add('');
  Bo3Page.Values[0] := GetBo3Path('');
  
  ConfigPage := CreateInputQueryPage(wpReady,
    ExpandConstant('{cm:ConfigTitle}'), ExpandConstant('{cm:ConfigDescription}'),
    'Configure the TikTok Bridge settings:');
  
  ConfigPage.Add(ExpandConstant('{cm:RconPassword}'), False);
  ConfigPage.Add(ExpandConstant('{cm:RconPort}'), False);
  ConfigPage.Add(ExpandConstant('{cm:WebhookPort}'), False);
  
  ConfigPage.Values[0] := '';
  ConfigPage.Values[1] := '27015';
  ConfigPage.Values[2] := '5000';
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  
  // Skip config page if going backwards
  if PageID = ConfigPage.ID then
    Result := False;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigFile: String;
  ConfigContent: String;
begin
  if CurStep = ssPostInstall then
  begin
    // Create bridge configuration file
    ConfigFile := ExpandConstant('{app}\bridge_config.py');
    ConfigContent := '# TikTok Bridge Configuration' + #13#10 +
                     '# Edit these values as needed' + #13#10 + #13#10 +
                     'RCON_HOST = "127.0.0.1"' + #13#10 +
                     'RCON_PORT = ' + ConfigPage.Values[1] + #13#10 +
                     'RCON_PASSWORD = "' + ConfigPage.Values[0] + '"' + #13#10 +
                     'WEBHOOK_PORT = ' + ConfigPage.Values[2] + #13#10;
    
    SaveStringToFile(ConfigFile, ConfigContent, False);
    
    // Create version file
    SaveStringToFile(ExpandConstant('{app}\version.json'), 
      '{"version": "' + ExpandConstant('{#MyAppVersion}') + '"}', False);
    
    // Update tiktok_bridge.py to use config
    if FileExists(ExpandConstant('{app}\tiktok_bridge.py')) then
    begin
      // This is handled by the Python script itself
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    // Clean up any additional files if needed
  end;
end;
