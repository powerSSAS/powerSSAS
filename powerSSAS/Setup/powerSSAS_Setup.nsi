; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_VERSION "0.3.1.5"

!define PRODUCT_NAME "powerSSAS"
!define PRODUCT_TITLE "powerSSAS for SQL Server 2005"
!define PRODUCT_PUBLISHER "powerSSAS"
!define PRODUCT_WEB_SITE "http://powerSSAS.codeplex.com"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_SETTINGS_KEY "Software\${PRODUCT_NAME}"
!define PRODUCT_SETTINGS_ROOT_KEY "HKCU"

!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION} has been installed on your computer.\r\nSee the website for examples on how to use it.\r\n\r\nClick Finish to close this wizard."
!define MUI_FINISHPAGE_TEXT_LARGE ""

!define INSTALL64 "$WINDIR\Microsoft.NET\Framework64\v2.0.50727\installUtil.exe"
!define INSTALL32 "$WINDIR\Microsoft.NET\Framework\v2.0.50727\installUtil.exe"
!define MAIN_DLL "powerSSAS.dll"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include Library.nsh

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\powerSSAS.ico" #"${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "..\powerSSAS.ico" #"${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "powerSSASHeader.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "powerSSAS.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_LINK "${PRODUCT_NAME} Homepage"
!define MUI_FINISHPAGE_LINK_LOCATION "${PRODUCT_WEB_SITE}"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
; Language files
!insertmacro MUI_LANGUAGE "English"
; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; MUI end ------

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "${PRODUCT_WEB_SITE}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_NAME}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "Test Application is a trademark of Fake company"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "? 2007 ${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Installer for ${PRODUCT_TITLE}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"

VIProductVersion "${PRODUCT_VERSION}"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_Setup(${PRODUCT_VERSION}).exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_SETTINGS_KEY}" "$INSTDIR"
RequestExecutionLevel admin
ShowInstDetails show
ShowUnInstDetails show
;XPStyle "on"

;Function .onInit
;         ${GetFileVersion} "..bin\debug\powerSSAS.dll" $PRODUCT_VERSION
;FunctionEnd

Section "MainSection" SEC01
  CreateDirectory "$INSTDIR"
  SetOutPath $INSTDIR
  SetOverwrite ifnewer
!insertmacro InstallLib DLL NOTSHARED NOREBOOT_NOTPROTECTED "..\bin\debug\powerSSAS.dll" "$INSTDIR\powerSSAS.dll" $INSTDIR\Temp
  CreateDirectory "$INSTDIR\FormatData"
  SetOutPath "$INSTDIR\FormatData"
  File "..\FormatData\powerSSAS.Format.ps1xml"
  CreateDirectory "$INSTDIR\TypeData"
  SetOutPath "$INSTDIR\TypeData"

  File "..\TypeData\powerSSAS.Types.ps1xml"
  CreateDirectory "$INSTDIR\Help"
  SetOutPath "$INSTDIR\Help"
  File "..\Help\powerSSAS.dll-help.xml"
  SetOutPath $INSTDIR
SectionEnd


Section "instutil"
  DetailPrint "About to Register Plugin using the .Net Instutil"
  DetailPrint ""
  
  IfFileExists "${INSTALL64}" inst64 inst32
inst64:
    DetailPrint "64 bit System Detected"
    nsExec::ExecToLog '"${INSTALL64}" ${MAIN_DLL} /LogFile=instutil.log'
    goto end
inst32:
    IfFileExists "${INSTALL32}" inst32a error
    inst32a:
      DetailPrint "32 bit System Detected"
      nsExec::ExecToLog '"${INSTALL32}" ${MAIN_DLL} /LogFile=instutil.log'
      goto end
error:
  DetailPrint "ERROR: Installer not found!"
end:

  Pop $0 # return value/error/timeout
  DetailPrint ""
  DetailPrint "       Return value: $0"
  DetailPrint ""
SectionEnd


Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallPath" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd



Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd


Section un.installutil

;rename "$INSTDIR\powerSSAS.dll" "$INSTDIR\powerSSAS.dll.tmp"
;rename "$INSTDIR\powerSSAS.dll.tmp" "$INSTDIR\powerSSAS.dll"

###############################################3
## start instutil section
  DetailPrint "About to UnRegister Plugin using the .Net Instutil"
  DetailPrint ""

  IfFileExists "${INSTALL64}" inst64 inst32
inst64:
    DetailPrint "64 bit System Detected"
    nsExec::ExecToLog '"${INSTALL64}" /u "$INSTDIR\${MAIN_DLL}" /LogFile=instutil.log'
    goto end
inst32:
    IfFileExists "${INSTALL32}" inst32a error
    inst32a:
      DetailPrint "32 bit System Detected"
      nsExec::ExecToLog '"${INSTALL32}" /u "$INSTDIR\${MAIN_DLL}" /LogFile=instutil.log'
      goto end
error:
  DetailPrint "ERROR: Installer not found!"
end:

  Pop $0 # return value/error/timeout
  DetailPrint ""
  DetailPrint "       Return value: $0"
  DetailPrint ""
## End instutil section
###############################################3
SectionEnd

Section Uninstall
deleteDll:
# cannot fully uninstall if VS.Net is running and has the dll open.
  !insertmacro UnInstallLib DLL NOTSHARED NOREBOOT_NOTPROTECTED $INSTDIR\powerSSAS.dll

  IfFileExists  "$INSTDIR\powerSSAS.dll" 0 fileDeleted
    # File is in use, can't just delete. Give user the chance to retry.

    MessageBox MB_RETRYCANCEL|MB_ICONSTOP "Failed to uninstall $INSTDIR\powerSSAS.dll $\n File may still be in use by some other application.$\n Please close all PowerShell applications before you Retry,$\n or press Cancel to keep this file." IDRETRY deleteDll
    Abort
fileDeleted:

## TODO - how to figure out that the uninstalllib command did not work

;Delete Files
  RMDir /r "$INSTDIR\*.*"
;Remove the installation directory
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey ${PRODUCT_SETTINGS_ROOT_KEY} "${PRODUCT_SETTINGS_KEY}"

  SetAutoClose false
SectionEnd

