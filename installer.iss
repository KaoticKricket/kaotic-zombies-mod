; Kaotic Zombies Interactive Mod Installer
; Inno Setup Script for Windows

#define MyAppName "Kaotic Zombies"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Kaotic Modding"
#define MyAppURL ""

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
PrivilegesRequired=admin
CreateAppDir=no
UsePreviousAppDir=no
DisableDirPage=no
DisableProgramGroupPage=yes
OutputDir=Output

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel2=This will install the Kaotic Zombies mod for Black Ops 3.%n%nThe mod adds TikTok/Tikfinity integration to your Zombies gameplay.
FinishedLabel=The Kaotic Zombies mod has been successfully installed.%n%n%nIMPORTANT: You must build the mod with BO3 Mod Tools before it will work in-game.%n%nNext steps:%n1. Install BO3 Mod Tools (free on Steam)%n2. Build the mod using Mod Tools Launcher%n3. Launch Black Ops 3%n4. Open Zombies%n5. Load the Kaotic Zombies mod%n6. Start KaoticListener.exe%n7. Open TikFinity and configure webhooks to http://127.0.0.1:8080/%n8. Connect TikFinity to TikTok LIVE%n9. Start streaming!%n%nSee README.md for detailed building instructions.

[CustomMessages]
Bo3PathTitle=Black Ops 3 Installation
Bo3PathDescription=Please select your Black Ops 3 installation directory.
Bo3PathBrowse=Browse...
Bo3PathInvalid=The specified directory does not contain a valid Black Ops 3 installation.

[Files]
; Mod files
Source: "zm_mod\scripts\zm\kaotic_zombies.gsc"; DestDir: "{app}\zm_mod\scripts\zm"; Flags: ignoreversion
Source: "zm_mod\scripts\zm\kaotic_zombies.csc"; DestDir: "{app}\zm_mod\scripts\zm"; Flags: ignoreversion
Source: "zm_mod\mod.csv"; DestDir: "{app}\zm_mod"; Flags: ignoreversion
Source: "zm_mod\zone_source\kaotic_zombies.zone"; DestDir: "{app}\zm_mod\zone_source"; Flags: ignoreversion

; HTTP Listener
Source: "KaoticListener.exe"; DestDir: "{app}"; Flags: ignoreversion

; Documentation
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}\Kaotic Listener"; Filename: "{app}\KaoticListener.exe"; WorkingDir: "{app}"; Comment: "Start Kaotic HTTP Listener"
Name: "{autoprograms}\{#MyAppName}\Uninstall"; Filename: "{uninstallexe}"; Comment: "Remove Kaotic Zombies Mod"
Name: "{autodesktop}\Kaotic Listener"; Filename: "{app}\KaoticListener.exe"; WorkingDir: "{app}"; Comment: "Start Kaotic HTTP Listener"

[Run]
Filename: "{app}\README.md"; Description: "Open README file"; Flags: shellexec postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}\zm_mod"

[Code]
var
  Bo3Page: TInputDirWizardPage;

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
  // Check for key BO3 files/folders - be more lenient
  Result := DirExists(Path + '\bin') or DirExists(Path + '\mods') or FileExists(Path + '\BlackOps3.exe');
  
  // If basic check passes, also try to check for mods folder specifically
  if Result then
  begin
    // It's okay if mods folder doesn't exist - installer will create it
    Result := True;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
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
end;

procedure InitializeWizard;
begin
  // Create custom pages
  Bo3Page := CreateInputDirPage(wpSelectDir,
    ExpandConstant('{cm:Bo3PathTitle}'), ExpandConstant('{cm:Bo3PathDescription}'),
    'Select the folder where Black Ops 3 is installed:', False, '');
  
  Bo3Page.Add('');
  Bo3Page.Values[0] := GetBo3Path('');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    // Clean up any additional files if needed
  end;
end;
