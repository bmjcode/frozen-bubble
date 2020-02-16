!define VERSION "2.213"

# This can be "win32" or "win64"
!ifndef PLATFORM
  !define PLATFORM "win64"
!endif

!if ${PLATFORM} == "win64"
  InstallDir "$PROGRAMFILES64\Frozen Bubble"
!else if ${PLATFORM} == "win32"
  InstallDir "$PROGRAMFILES32\Frozen Bubble"
!else
  !error "Platform must be one of 'win32' or 'win64'."
!endif

Name "Frozen Bubble"
OutFile "..\frozen-bubble-${VERSION}-${PLATFORM}.exe"
InstallDirRegKey HKLM "Software\Frozen Bubble" ""
RequestExecutionLevel admin
XPStyle on
LicenseData "..\COPYING"

; ------------------------------------------------------------------------

Page license
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

; ------------------------------------------------------------------------

Section "Frozen Bubble"
  SectionIn RO

  SetOutPath $INSTDIR
  File "..\frozen-bubble.exe"
  File "..\libiconv-2__.dll"
  File "..\libpng15-15__.dll"
  File "..\zlib1__.dll"
  File "..\share\icons\frozen-bubble.ico"

  !if ${PLATFORM} == "win64"
    SetRegView 64
  !else if ${PLATFORM} == "win32"
    SetRegView 32
  !endif

  ; Create a Start Menu shortcut
  CreateDirectory "$SMPROGRAMS\Frozen Bubble"
  CreateShortcut "$SMPROGRAMS\Frozen Bubble\Frozen Bubble.lnk" "$INSTDIR\frozen-bubble.exe" "" "$INSTDIR\frozen-bubble.ico"

  ; Write the installation path into the registry
  WriteRegStr HKLM "Software\Frozen Bubble" "" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Frozen Bubble" "DisplayName" "Frozen Bubble"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Frozen Bubble" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Frozen Bubble" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Frozen Bubble" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Frozen Bubble Level Editor"
  File "..\frozen-bubble-editor.exe"
  CreateShortcut "$SMPROGRAMS\Frozen Bubble\Frozen Bubble Level Editor.lnk" "$INSTDIR\frozen-bubble-editor.exe" "" "$INSTDIR\frozen-bubble.ico"
SectionEnd

Section "Create desktop shortcut"
  CreateShortcut "$DESKTOP\Frozen Bubble.lnk" "$INSTDIR\frozen-bubble.exe" "" "$INSTDIR\frozen-bubble.ico"
SectionEnd

; ------------------------------------------------------------------------

Section "Uninstall"
  !if ${PLATFORM} == "win64"
    SetRegView 64
  !else if ${PLATFORM} == "win32"
    SetRegView 32
  !endif

  ; Delete registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Frozen Bubble"
  DeleteRegKey HKLM "Software\Frozen Bubble"

  ; Delete shortcuts
  Delete "$SMPROGRAMS\Frozen Bubble\Frozen Bubble.lnk"
  Delete "$SMPROGRAMS\Frozen Bubble\Frozen Bubble Level Editor.lnk"
  Delete "$DESKTOP\Frozen Bubble.lnk"
  RMDir "$SMPROGRAMS\Frozen Bubble"

  ; Delete application files
  Delete "$INSTDIR\frozen-bubble.exe"
  Delete "$INSTDIR\frozen-bubble-editor.exe"
  Delete "$INSTDIR\libiconv-2__.dll"
  Delete "$INSTDIR\libpng15-15__.dll"
  Delete "$INSTDIR\zlib1__.dll"
  Delete "$INSTDIR\frozen-bubble.ico"
  Delete "$INSTDIR\uninstall.exe"

  ; Remove the application directory if it's empty
  RMDir "$INSTDIR"
SectionEnd
