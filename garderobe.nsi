;-------------------------------
; LiYing NSIS Installer
;
; Richard Bown
; November 2019
;-------------------------------
!include FontReg.nsh
!include FontName.nsh
!include WinMessages.nsh

; Request application privileges for Windows Vista\7 etc
;
RequestExecutionLevel admin

; We're using the modern UI
;
!include "MUI.nsh"

; The name of the installer
Name "LY-win64-alpha-2022"
Caption "LiYing Windows32 Alpha Build 2022"

!define icon "icon.ico"
!define COMPANY "LiYing"
!define SOFTWARE "LiYing"

; The file to write
OutFile "LiYing-win64-alpha-2022.exe"

; The default installation directory
;
InstallDir $PROGRAMFILES\${COMPANY}\${SOFTWARE}

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
;
InstallDirRegKey HKLM "Software\${COMPANY}\${SOFTWARE}" "Install_Dir"

; Application icon
;
Icon "data\pixmaps\icons\rg-rwb-rose3-128x128.ico"

; MUI stuff
;
!insertmacro MUI_PAGE_LICENSE "COPYING.txt"
!insertmacro MUI_LANGUAGE "English"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "LiYing"

    SectionIn RO

    ; Set output path to the installation directory.
    SetOutPath $INSTDIR

    File "COPYING.txt"
    File "README.md"
    File "README-linux.txt"
    File "AUTHORS.txt"

    ; The files we are building into the package
    ;
    File "..\release\release\liying.exe"
    File "data\dlls\icudt52.dll"
    File "data\dlls\icuin52.dll"
    File "data\dlls\icuuc52.dll"
    File "data\dlls\libgcc_s_dw2-1.dll"
    File "data\dlls\libgcc_s_seh-1.dll"
    File "data\dlls\libstdc++-6.dll"
    File "data\dlls\libwinpthread-1.dll"
    File "data\dlls\Qt5Core.dll"
    File "data\dlls\Qt5Cored.dll"
    File "data\dlls\Qt5Gui.dll"
    File "data\dlls\Qt5Guid.dll"
    File "data\dlls\Qt5Network.dll"
    File "data\dlls\Qt5Networkd.dll"
    File "data\dlls\Qt5PrintSupport.dll"
    File "data\dlls\Qt5PrintSupportd.dll"
    File "data\dlls\Qt5Svg.dll"
    File "data\dlls\Qt5Svgd.dll"
    File "data\dlls\Qt5Widgets.dll"
    File "data\dlls\Qt5Widgetsd.dll"
    File "data\dlls\Qt5Xml.dll"
    File "data\dlls\Qt5Xmld.dll"
    File "data\locale\ca.qm"
    File "data\locale\cs.qm"
    File "data\locale\cy.qm"
    File "data\locale\de.qm"
    File "data\locale\en.qm"
    File "data\locale\en_GB.qm"
    File "data\locale\en_US.qm"
    File "data\locale\es.qm"
    File "data\locale\et.qm"
    File "data\locale\eu.qm"
    File "data\locale\fi.qm"
    File "data\locale\fr.qm"
    File "data\locale\id.qm"
    File "data\locale\it.qm"
    File "data\locale\ja.qm"
    File "data\locale\nl.qm"
    File "data\locale\pl.qm"
    File "data\locale\pt_BR.qm"
    File "data\locale\ru.qm"
    File "data\locale\sv.qm"
    File "data\locale\zh_CN.qm"
    File "data\locale\rosegarden.qm"
    File "data\dlls\zlib1.dll"

    ;File \r "accessible"
    File /r "bearer"
    File /r "iconengines"
    File /r "imageformats"
    File /r "platforms"
    File /r "printsupport"

    ; More resources
    ;
    File "data\pixmaps\icons\rg-rwb-rose3-128x128.ico"

    ; Write the installation path into the registry
    WriteRegStr HKLM "Software\${COMPANY}\${SOFTWARE}" "Install_Dir" "$INSTDIR"
    WriteRegStr HKCR "LiYing\DefaultIcon" "" "$INSTDIR\rg-rwb-rose3-128x128.ico"

    ; Write the uninstall keys for Windows
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LiYing" "DisplayName" "LiYing"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LiYing" "UninstallString" '"$INSTDIR\uninstall.exe"'

    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LiYing" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LiYing" "NoRepair" 1
    WriteUninstaller "uninstall.exe"

SectionEnd

Section "Fonts"
    ; Using the FontName package this is very easy - works out the install path for us and
    ; we just need to specify the file name of the fonts.
    ;

    ; Copy the FONTS variable into FONT_DIR
    ;
    StrCpy $FONT_DIR $FONTS

    ; Remove and then install fonts
    ;
    !insertmacro RemoveTTFFont "GNU-LilyPond-feta-design20.ttf"
    !insertmacro RemoveTTFFont "GNU-LilyPond-feta-nummer-10.ttf"
    !insertmacro RemoveTTFFont "GNU-LilyPond-parmesan-20.ttf"

    !insertmacro InstallTTFFont "data\fonts\GNU-LilyPond-feta-design20.ttf"
    !insertmacro InstallTTFFont "data\fonts\GNU-LilyPond-feta-nummer-10.ttf"
    !insertmacro InstallTTFFont "data\fonts\GNU-LilyPond-parmesan-20.ttf"

    ; Complete font registration without reboot
    ;
    SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=5000

SectionEnd


; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

    CreateDirectory "$SMPROGRAMS\LiYing"
    CreateShortCut "$SMPROGRAMS\LiYing\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    ;CreateShortCut "$SMPROGRAMS\LiYing\LiYing.lnk" "$INSTDIR\liying.exe" "" "$INSTDIR\garderobe.nsi" 0
    CreateShortCut "$SMPROGRAMS\LiYing\LiYing.lnk" "$INSTDIR\liying.exe" "" "$INSTDIR\rg-rwb-rose3-128x128.ico"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

    ; Remove registry keys
    ;
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LiYing"
    DeleteRegKey HKLM "Software\${COMPANY}\${SOFTWARE}"

    Delete "$INSTDIR\COPYING.txt"
    Delete "$INSTDIR\README.txt"
    Delete "$INSTDIR\README-linux.txt"
    Delete "$INSTDIR\AUTHORS.txt"

    ; Remove files and uninstaller
    ;
    Delete $INSTDIR\*uninstall.exe
    Delete "$INSTDIR\liying.exe"
    Delete "$INSTDIR\icudt52.dll"
    Delete "$INSTDIR\icuin52.dll"
    Delete "$INSTDIR\icuuc52.dll"
    Delete "$INSTDIR\libgcc_s_dw2-1.dll"
    Delete "$INSTDIR\libgcc_s_seh-1.dll"
    Delete "$INSTDIR\libstdc++-6.dll"
    Delete "$INSTDIR\libwinpthread-1.dll"
    Delete "$INSTDIR\Qt5Core.dll"
    Delete "$INSTDIR\Qt5Cored.dll"
    Delete "$INSTDIR\Qt5Gui.dll"
    Delete "$INSTDIR\Qt5Guid.dll"
    Delete "$INSTDIR\Qt5Network.dll"
    Delete "$INSTDIR\Qt5Networkd.dll"
    Delete "$INSTDIR\Qt5PrintSupport.dll"
    Delete "$INSTDIR\Qt5PrintSupportd.dll"
    Delete "$INSTDIR\Qt5Svg.dll"
    Delete "$INSTDIR\Qt5Svgd.dll"
    Delete "$INSTDIR\Qt5Widgets.dll"
    Delete "$INSTDIR\Qt5Widgetsd.dll"
    Delete "$INSTDIR\Qt5Xml.dll"
    Delete "$INSTDIR\Qt5Xmld.dll"
    Delete "$INSTDIR\ca.qm"
    Delete "$INSTDIR\cs.qm"
    Delete "$INSTDIR\cy.qm"
    Delete "$INSTDIR\de.qm"
    Delete "$INSTDIR\en.qm"
    Delete "$INSTDIR\en_GB.qm"
    Delete "$INSTDIR\en_US.qm"
    Delete "$INSTDIR\es.qm"
    Delete "$INSTDIR\et.qm"
    Delete "$INSTDIR\eu.qm"
    Delete "$INSTDIR\fi.qm"
    Delete "$INSTDIR\fr.qm"
    Delete "$INSTDIR\id.qm"
    Delete "$INSTDIR\it.qm"
    Delete "$INSTDIR\ja.qm"
    Delete "$INSTDIR\nl.qm"
    Delete "$INSTDIR\pl.qm"
    Delete "$INSTDIR\pt_BR.qm"
    Delete "$INSTDIR\ru.qm"
    Delete "$INSTDIR\sv.qm"
    Delete "$INSTDIR\zh_CN.qm"
    Delete "$INSTDIR\rosegarden.qm"
    Delete "$INSTDIR\zlib1.dll"

    Delete "$INSTDIR\application.rc"
    Delete "$INSTDIR\rg-rwb-rose3-128x128.ico"

    ; Remove shortcuts, if any
    Delete "$SMPROGRAMS\LiYing\*.*"
    Delete "$INSTDIR\LiYing\*.*"

    ; Remove the data directory and subdirs
    ;
    RMDir /r "$INSTDIR\accessible"
    RMDir /r "$INSTDIR\bearer"
    RMDir /r "$INSTDIR\iconengines"
    RMDir /r "$INSTDIR\imageformats"
    RMDir /r "$INSTDIR\platforms"
    RMDir /r "$INSTDIR\printsupport"

    Delete "$INSTDIR\accessible"
    Delete "$INSTDIR\bearer"
    Delete "$INSTDIR\iconengines"
    Delete "$INSTDIR\imageformats"
    Delete "$INSTDIR\platforms"
    Delete "$INSTDIR\printsupport"

    ; Remove directories used
    ;
    RMDir "$SMPROGRAMS\LiYing"
    RMDir "$INSTDIR"

SectionEnd

