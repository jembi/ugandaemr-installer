;--------------------------------
;Defines
!include "MUI2.nsh"
!include "Registry.nsh"
!include "Sections.nsh"

Name "Uganda EMR"
!define JavaRegKey 'HKLM "Software\JavaSoft\Java Runtime Environment" ""'
!define MUI_ICON "..\software/favicon.ico"
!define MUI_UNICON "..\software/favicon.ico"

Var SMDir ;Start menu folder
Var errorsrc
;!define MUI_STARTMENUPAGE_DEFAULTFOLDER "MY Program" ;Default, name is used if not defined


!define MUI_HEADERIMAGE_BITMAP "software64\logo.bmp"
!define MUI_HEADERIMAGE_RIGHT
!define TOMCATDIR "C:\Program Files\UgandaEMR\UgandaEMRTomcat\"
RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  !insertmacro MUI_PAGE_LICENSE "..\includes\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_STARTMENU 0 $SMDir
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------

InstallDir "C:\Program Files\UgandaEMR"	;This line creates a default location for the installation. Note that C:\Program Files is a constant value provided by NSIS
DirText "OpenMrs will install in this directory"
!define instDirectory "C:\Program Files\UgandaEMR"

OutFile "tomcat.exe"

;-------------------------Splash Screen For installer--------------------------------
  XPStyle on
Function .onInit

UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
	# the plugins dir is automatically deleted when the installer exits
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "..\includes\splash.bmp"
     advsplash::show 5000 600 400 -1 $PLUGINSDIR\splash

	Pop $0 ; $0 has '1' if the user closed the splash screen early,
			; '0' if everything closed normally, and '-1' if some error occurred.
FunctionEnd
;===========================================Installer Sections============================================

Var IPAddressControl
Var IPADR
 

 
;Installing Tomcat
Section 'Tomcat 7.0.65' SecTomcat
  SectionIn RO
  SetOutPath '$TEMP'
  SetOverwrite on
  File '..\includes\software\apache-tomcat-7.0.68.exe'
  ExecWait '$TEMP\apache-tomcat-7.0.68.exe /S /D=C:\Program Files\UgandaEMR\UgandaEMRTomcat' $0
  DetailPrint '..Java Runtime Setup exit code = $0'
  Delete '$TEMP\apache-tomcat-7.0.68.exe'

;SetOutPath "C:\Program Files\UgandaEMR\"
;File /r "software64\apache-tomcat"
nsExec::Exec '"C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\Tomcat7" //IS//UgandaEMRTomcat --DisplayName="UgandaEMRTomcat" --Description="This Service starts UgandaEMRTomcat" --Install="C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\UgandaEMRTomcat.exe" --Jvm="C:\Program Files\Java\jre1.8.0_131\bin\server\jvm.dll" --StartMode=jvm --StopMode=jvm --StartClass=org.apache.catalina.startup.Bootstrap --StartParams=start --StopClass=org.apache.catalina.startup.Bootstrap --StopParams=stop --Classpath="C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\bootstrap.jar;C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\tomcat-juli.jar" --StdError=auto --StdOutput=auto --LogPrefix=commons-daemon --LogLevel=Info --User=root --Password=openmrs --JvmMs=256 --JvmMx=512 --StartPath="C:\Program Files\UgandaEMR\UgandaEMRTomcat" --StopPath="C:\Program Files\UgandaEMR\UgandaEMRTomcat" --LogPath="C:\Program Files\UgandaEMR\UgandaEMRTomcat\logs" --Startup=auto'
nsExec::Exec '"C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\UgandaEMRTomcat" //US//UgandaEMRTomcat ++JvmOptions="-XX:MaxPermSize=512m" ++JvmOptions="-Xms128m" ++JvmOptions="-Xmx1024m" ++JvmOptions="-Dorg.apache.el.parse.SKIP_IDENTIFIER_CHECK=true"'
Rename "C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\Tomcat7.exe" "C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\UgandaEMRTomcat.exe"
Rename "C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\Tomcat7w.exe" "C:\Program Files\UgandaEMR\UgandaEMRTomcat\bin\UgandaEMRTomcatw.exe"
SetOutPath 'C:\Program Files\UgandaEMR\UgandaEMRTomcat\conf'
SetOverwrite on
File '..\includes\scripts\server.xml'
SectionEnd