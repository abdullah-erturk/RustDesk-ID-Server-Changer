
	:: INFO:
	:: RustDesk Github: https://github.com/rustdesk/rustdesk
	:: RustDesk ID Changer Github: https://github.com/abdullah-erturk/RustDesk-ID-Changer

::===============================================================================================================
@echo off
mode con:cols=90 lines=50
title RustDesk ID ^& Server Changer v4 by Abdullah ERTšRK

:: Language check via Get-UICulture (Display Language)
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-UICulture).TwoLetterISOLanguageName"') do set OS_LANG=%%a
set LANG_TR=0
if /i "%OS_LANG%"=="tr" set LANG_TR=1

net file 1>nul 2>nul && goto :Main || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c ""%~fnx0""""'"
goto :eof
::===============================================================================================================
:Main
cls
if %LANG_TR%==1 chcp 857 >nul 2>&1

:: Log file: prefer script directory, fall back to %TEMP% if not writable (e.g. read-only USB)
set "LOGFILE=%~dp0RustDesk_Changer.log"
2>nul (>>"%~dp0.rdwtest" echo.) && (del "%~dp0.rdwtest" >nul 2>&1) || set "LOGFILE=%TEMP%\RustDesk_Changer.log"

:: Work inside %TEMP% so generated helper scripts are always in a writable location
pushd "%temp%" >nul 2>&1

:: Feature: detect RustDesk install path dynamically from the Windows Registry
call :DetectPath

if not exist "%RUSTDESK_PATH%\rustdesk.exe" (
  echo.
  if %LANG_TR%==1 (
    echo RustDesk kurulu de§il, ”nce RustDesk'i kurun.
    echo.
    echo €kŸ i‡in herhangi bir tuŸa basn.
  ) else (
    echo RustDesk is not installed, install RustDesk first.
    echo.
    echo Press any key to exit.
  )
  pause >nul
  exit
)

:: Current ID (full path, no cd needed)
for /f "usebackq delims=" %%i in (`"%RUSTDESK_PATH%\rustdesk.exe" --get-id ^| more`) do set "rustdesk_id=%%i"

:: Feature: status indicator (current server)
call :GetServerStatus

:: Minimum accepted custom-ID length varies by OS/RustDesk build:
::   Windows 10/11 client = 6, Windows 7/8.x = 7, Windows Server = 8
set "MIN_LEN=6"
ver | findstr /c:"Version 10." >nul || set "MIN_LEN=7"
set "INST_TYPE="
for /f "tokens=3" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v InstallationType 2^>nul') do set "INST_TYPE=%%i"
if /i "%INST_TYPE%"=="Server" set "MIN_LEN=8"

:Run
echo.
echo ==========================================================================================
echo.
if %LANG_TR%==1 goto Menu_TR
goto Menu_EN

:Menu_TR
echo			  RustDesk ID ^& Server Changer by Abdullah ERTšRK
echo.
echo.		github.com/abdullah-erturk ^| erturk-dev.netlify.app
echo.
echo.	  Mevcut ID : %rustdesk_id%     Sunucu : %SERVER_STATUS%
echo.
echo.	-----------------------------------------------------------------
echo	 	  1 - RustDesk ID'sini bilgisayar adyla de§iŸtir : "%computername%"
echo	 	  2 - RustDesk ID'sini 9 haneli rastgele saylarla de§iŸtir
echo	 	  3 - RustDesk ID'sini belirtti§iniz de§ere ayarlayn
echo.	-----------------------------------------------------------------
echo	 	  4 - Public Sunucuya Ge‡ [Private Sunucu Bilgisini Temizle]
echo	 	  5 - Private Sunucuya Ge‡ [Yedeklenen Private Sunucu Bilgisini Uygula]
echo	 	  6 - Yeni Private Sunucu Tanmla
echo	 	  7 - Tam Yaplandrmay ˜‡e Aktar [Config String]
echo.	-----------------------------------------------------------------
echo	 	  8 - Kalc žifre Ayarla
echo	 	  9 - Son ID De§iŸikli§ini Geri Al [Undo]
echo	 	  P - Ayarlar Kilit PIN'ini Sfrla
echo	 	  0 - Private Sunucu Yedeklerini Sil
echo	 	  X - €IKIž
echo.
echo ==========================================================================================
echo.
choice /c 1234567890PX /n /m "Se‡iminiz [1-2-3-4-5-6-7-8-9-0-P-X] : "
goto Menu_Choice

:Menu_EN
echo			  RustDesk ID ^& Server Changer by Abdullah ERTURK
echo.
echo.		github.com/abdullah-erturk ^| erturk-dev.netlify.app
echo.
echo.	  Current ID : %rustdesk_id%     Server : %SERVER_STATUS%
echo.
echo.	-----------------------------------------------------------------
echo	 	  1 - Set RustDesk ID with computer name : "%computername%"
echo	 	  2 - Set RustDesk ID with 9-digit random numbers
echo	 	  3 - Set RustDesk ID to the value you specify
echo.	-----------------------------------------------------------------
echo	 	  4 - Set Public Server [Clear Custom Server Info]
echo	 	  5 - Set Private Server [Apply Backed-up Custom Server Info]
echo	 	  6 - Set New Private Server
echo	 	  7 - Import Full Configuration [Config String]
echo.	-----------------------------------------------------------------
echo	 	  8 - Set Permanent Password
echo	 	  9 - Undo Last ID Change
echo	 	  P - Reset Settings-Lock PIN
echo	 	  0 - Delete Custom Server Backups
echo	 	  X - Exit
echo.
echo ==========================================================================================
echo.
choice /c 1234567890PX /n /m "Your Choice [1-2-3-4-5-6-7-8-9-0-P-X] : "
goto Menu_Choice

:Menu_Choice
echo.
if errorlevel 12 Exit
if errorlevel 11 goto :Reset_PIN
if errorlevel 10 goto :Delete_Backups
if errorlevel 9 goto :Restore_ID
if errorlevel 8 goto :Set_Password
if errorlevel 7 goto :Config_Import
if errorlevel 6 goto :Server_Private_New
if errorlevel 5 goto :Server_Private
if errorlevel 4 goto :Server_Public
if errorlevel 3 goto :ID_UserDefined
if errorlevel 2 goto :ID_Random
if errorlevel 1 goto :ID_Host
echo.
::===============================================================================================================
:ID_Host
:: Computer name must meet the OS-required minimum length, otherwise RustDesk rejects it
set "NAME_OK=1"
if "%MIN_LEN%"=="8" if "%computername:~7,1%"=="" set "NAME_OK=0"
if "%MIN_LEN%"=="7" if "%computername:~6,1%"=="" set "NAME_OK=0"
if "%MIN_LEN%"=="6" if "%computername:~5,1%"=="" set "NAME_OK=0"
if "%NAME_OK%"=="0" (
    echo.
    if %LANG_TR%==1 (
        echo Uyar: Bilgisayar ad "%computername%" en az %MIN_LEN% karakter de§il.
        echo Bu iŸletim sisteminde RustDesk en az %MIN_LEN% karakterlik ID ister; iŸlem yaplmad.
        echo Bunun yerine 2. veya 3. se‡ene§i kullanabilirsiniz.
    ) else (
        echo Warning: Computer name "%computername%" is shorter than %MIN_LEN% characters.
        echo RustDesk requires at least %MIN_LEN% characters on this OS; no action taken.
        echo Use option 2 or 3 instead.
    )
    call :Log "ID host SKIPPED: computer name too short (min=%MIN_LEN%)"
    goto :done
)
set "RD_ID_MODE=host"
set "RUSTDESK_NEW_ID="
goto :RunIDSet
::===============================================================================================================
:ID_Random
set "RD_ID_MODE=random"
set "RUSTDESK_NEW_ID="
goto :RunIDSet
::===============================================================================================================
:ID_UserDefined
echo.
:: MIN_LEN is computed in :Main (Win10/11=6, Win7/8=7, Server=8)
if %LANG_TR%==1 (
    echo YEN˜ RUSTDESK ID DE¦ER˜ EN AZ %MIN_LEN% KARAKTER OLMALIDIR
    echo.
    goto Ask_ID_TR
) else (
    echo THE NEW RUSTDESK ID VALUE MUST BE AT LEAST %MIN_LEN% CHARACTERS
    echo.
    goto Ask_ID_EN
)

:Ask_ID_TR
set "RUSTDESK_NEW_ID="
set /p RUSTDESK_NEW_ID="RustDesk ID Girin (En az %MIN_LEN% karakter): "
if not defined RUSTDESK_NEW_ID (
    echo Hata: ID boŸ olamaz!
    echo.
    goto Ask_ID_TR
)
set "LEN_OK=1"
if "%MIN_LEN%"=="8" if "%RUSTDESK_NEW_ID:~7,1%"=="" set "LEN_OK=0"
if "%MIN_LEN%"=="7" if "%RUSTDESK_NEW_ID:~6,1%"=="" set "LEN_OK=0"
if "%MIN_LEN%"=="6" if "%RUSTDESK_NEW_ID:~5,1%"=="" set "LEN_OK=0"
if "%LEN_OK%"=="0" (
    echo Hata: ID en az %MIN_LEN% karakter olmaldr!
    echo.
    goto Ask_ID_TR
)
set "RD_ID_MODE=custom"
goto :RunIDSet

:Ask_ID_EN
set "RUSTDESK_NEW_ID="
set /p RUSTDESK_NEW_ID="Enter RustDesk ID (At least %MIN_LEN% characters): "
if not defined RUSTDESK_NEW_ID (
    echo Error: ID cannot be empty!
    echo.
    goto Ask_ID_EN
)
set "LEN_OK=1"
if "%MIN_LEN%"=="8" if "%RUSTDESK_NEW_ID:~7,1%"=="" set "LEN_OK=0"
if "%MIN_LEN%"=="7" if "%RUSTDESK_NEW_ID:~6,1%"=="" set "LEN_OK=0"
if "%MIN_LEN%"=="6" if "%RUSTDESK_NEW_ID:~5,1%"=="" set "LEN_OK=0"
if "%LEN_OK%"=="0" (
    echo Error: ID must be at least %MIN_LEN% characters!
    echo.
    goto Ask_ID_EN
)
set "RD_ID_MODE=custom"
goto :RunIDSet
::===============================================================================================================
:RunIDSet
echo.
set "RUSTDESK_EXE=%RUSTDESK_PATH%\rustdesk.exe"
set "RD_OLD_ID=%rustdesk_id%"
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_ID_Set.ps1
echo $mode = $env:RD_ID_MODE >> RustDesk_ID_Set.ps1
echo if ^($mode -eq "host"^) { $val = hostname } elseif ^($mode -eq "random"^) { $val = -join ^(^(48..57^) ^| Get-Random -Count 9 ^| ForEach-Object {[char]$_}^) } else { $val = $env:RUSTDESK_NEW_ID } >> RustDesk_ID_Set.ps1
echo $candidates = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml","$env:APPDATA\RustDesk\config\RustDesk.toml"^) >> RustDesk_ID_Set.ps1
echo $found = @^($candidates ^| Where-Object { Test-Path $_ }^) >> RustDesk_ID_Set.ps1
echo if ^($found.Count -eq 0^) { Write-Host "CONFIG_NOT_FOUND"; exit 2 } >> RustDesk_ID_Set.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_ID_Set.ps1
echo foreach ^($cfg in $found^) { Copy-Item -Path $cfg -Destination "$cfg.idbackup" -Force -ErrorAction SilentlyContinue; $c = Get-Content $cfg; $c = $c ^| Where-Object { $_ -notmatch "^^\s*enc_id\s*=" -and $_ -notmatch "^^\s*id\s*=" }; $c = @^("id = '" + $val + "'"^) + $c; $c ^| Set-Content $cfg } >> RustDesk_ID_Set.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_ID_Set.ps1
echo Start-Sleep -Seconds 2 >> RustDesk_ID_Set.ps1
echo $verify = "" >> RustDesk_ID_Set.ps1
echo try { $verify = ^(^& $env:RUSTDESK_EXE --get-id ^| Out-String^).Trim^(^) } catch {} >> RustDesk_ID_Set.ps1
if %LANG_TR%==1 (
    echo Write-Host ^("Eski ID : " + $env:RD_OLD_ID^) >> RustDesk_ID_Set.ps1
    echo Write-Host ^("Yeni ID : " + $verify^) >> RustDesk_ID_Set.ps1
) else (
    echo Write-Host ^("Current ID : " + $env:RD_OLD_ID^) >> RustDesk_ID_Set.ps1
    echo Write-Host ^("New ID     : " + $verify^) >> RustDesk_ID_Set.ps1
)
echo if ^($verify -eq $val^) { exit 0 } else { exit 1 } >> RustDesk_ID_Set.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File RustDesk_ID_Set.ps1
set "RD_RESULT=%errorlevel%"
if "%RD_RESULT%"=="2" (
    if %LANG_TR%==1 (
        echo Hata: RustDesk yaplandrma dosyas bulunamad. ID de§iŸtirilemedi.
    ) else (
        echo Error: RustDesk configuration file not found. ID not changed.
    )
    call :Log "ID change FAILED (mode=%RD_ID_MODE%): config not found"
    goto :done
)
call :RestartGUI
call :GetServerStatus
echo.
if "%RD_RESULT%"=="0" (
    if %LANG_TR%==1 (
        echo Do§rulama: ID baŸaryla de§iŸtirildi.
    ) else (
        echo Verification: ID changed successfully.
    )
) else (
    if %LANG_TR%==1 (
        echo Uyar: Yeni ID yazld ancak RustDesk farkl bir ID atad.
    ) else (
        echo Warning: The new ID was written but RustDesk assigned a different ID.
    )
)
echo %SERVER_STATUS%| findstr /b /c:"Public" >nul
if not errorlevel 1 if not "%RD_RESULT%"=="0" (
    if %LANG_TR%==1 (
        echo Not: Public sunucu ”zel/harf i‡eren ID'leri kabul etmeyip numerik ID atayabilir.
        echo      ™zel ID kullanmak i‡in bir Private sunucuya ge‡in.
    ) else (
        echo Note: The Public server may reject custom/alphabetic IDs and assign a numeric one.
        echo       Switch to a Private server to use a custom ID.
    )
)
call :Log "ID set (mode=%RD_ID_MODE%) result=%RD_RESULT% server=%SERVER_STATUS%"
goto :done
::===============================================================================================================
:Restore_ID
echo.
set "RUSTDESK_EXE=%RUSTDESK_PATH%\rustdesk.exe"
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_ID_Restore.ps1
echo $candidates = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml","$env:APPDATA\RustDesk\config\RustDesk.toml"^) >> RustDesk_ID_Restore.ps1
echo $found = @^($candidates ^| Where-Object { Test-Path $_ }^) >> RustDesk_ID_Restore.ps1
echo if ^($found.Count -eq 0^) { Write-Host "CONFIG_NOT_FOUND"; exit 2 } >> RustDesk_ID_Restore.ps1
echo $haveBk = @^($found ^| Where-Object { Test-Path ^($_ + ".idbackup"^) }^) >> RustDesk_ID_Restore.ps1
echo if ^($haveBk.Count -eq 0^) { Write-Host "NO_BACKUP"; exit 3 } >> RustDesk_ID_Restore.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_ID_Restore.ps1
echo foreach ^($cfg in $haveBk^) { Copy-Item -Path ^($cfg + ".idbackup"^) -Destination $cfg -Force } >> RustDesk_ID_Restore.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_ID_Restore.ps1
echo Start-Sleep -Seconds 2 >> RustDesk_ID_Restore.ps1
echo $verify = "" >> RustDesk_ID_Restore.ps1
echo try { $verify = ^(^& $env:RUSTDESK_EXE --get-id ^| Out-String^).Trim^(^) } catch {} >> RustDesk_ID_Restore.ps1
if %LANG_TR%==1 (
    echo Write-Host ^("Geri Yuklenen ID : " + $verify^) >> RustDesk_ID_Restore.ps1
) else (
    echo Write-Host ^("Restored ID : " + $verify^) >> RustDesk_ID_Restore.ps1
)
echo exit 0 >> RustDesk_ID_Restore.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File RustDesk_ID_Restore.ps1
set "RD_RESULT=%errorlevel%"
if "%RD_RESULT%"=="2" (
    if %LANG_TR%==1 (
        echo Hata: RustDesk yaplandrma dosyas bulunamad.
    ) else (
        echo Error: RustDesk configuration file not found.
    )
    call :Log "ID restore FAILED: config not found"
    goto :done
)
if "%RD_RESULT%"=="3" (
    if %LANG_TR%==1 (
        echo Geri alnacak bir ID yede§i bulunamad. ™nce bir ID de§iŸikli§i yapmalsnz.
    ) else (
        echo No ID backup found to restore. Change an ID first.
    )
    call :Log "ID restore FAILED: no backup"
    goto :done
)
call :RestartGUI
echo.
if %LANG_TR%==1 (
    echo Do§rulama: ™nceki ID baŸaryla geri yklendi.
) else (
    echo Verification: Previous ID restored successfully.
)
call :Log "ID restored from backup"
goto :done
::===============================================================================================================
:Server_Public
echo.
echo $isPublic = $true > check_public.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> check_public.ps1
echo foreach ^($path in $paths^) { if ^(Test-Path $path^) { $content = Get-Content $path; if ^(^($content -match "^^custom-rendezvous-server"^) -or ^($content -match "^^api-server"^) -or ^($content -match "^^custom-rs-server"^)^) { $isPublic = $false } } } >> check_public.ps1
echo if ^($isPublic^) { exit 1 } else { exit 0 } >> check_public.ps1
powershell.exe -ExecutionPolicy Bypass -File check_public.ps1
if errorlevel 1 (
    del check_public.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Public Sunucu kullanyorsunuz. ˜Ÿlem yaplmad.
    ) else (
        echo You are already using the Public Server. No action taken.
    )
    goto :done
)
del check_public.ps1 >nul 2>&1

echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Server_Public.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_Server_Public.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> RustDesk_Server_Public.ps1
echo foreach ^($path in $paths^) { >> RustDesk_Server_Public.ps1
echo     if ^(Test-Path $path^) { >> RustDesk_Server_Public.ps1
echo         $content = Get-Content $path >> RustDesk_Server_Public.ps1
echo         $hasCustom = ^($content -match "^^custom-rendezvous-server" -or $content -match "^^api-server" -or $content -match "^^custom-rs-server"^) >> RustDesk_Server_Public.ps1
echo         if ^($hasCustom^) { Copy-Item -Path $path -Destination "$path.backup" -Force; if ^(-not ^(Test-Path "$path.backup"^)^) { exit 3 } } >> RustDesk_Server_Public.ps1
echo         $newContent = $content -replace "^^custom-rendezvous-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^^custom-rs-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^^api-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^^custom-api-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^^key.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent ^| Where-Object { $_.Trim^(^) -ne "" } >> RustDesk_Server_Public.ps1
echo         $newContent ^| Set-Content $path >> RustDesk_Server_Public.ps1
echo     } >> RustDesk_Server_Public.ps1
echo } >> RustDesk_Server_Public.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Public.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Public.ps1
if errorlevel 3 (
    if %LANG_TR%==1 (
        echo Yedekleme srasnda bir hata oluŸtu. ˜zinleri kontrol edin. ˜Ÿleme devam edilemedi.
    ) else (
        echo An error occurred during backup. Check permissions. Process aborted.
    )
    call :Log "Switch to Public FAILED: backup error"
    goto :done
)
call :RestartGUI
echo.
if %LANG_TR%==1 (
    echo Mevcut private sunucu ayarlar yedeklendi ve Public sunucuya ge‡ildi.
) else (
    echo Current custom server settings backed up and switched to Public server.
)
call :GetServerStatus
if %LANG_TR%==1 (
    echo Do§rulama / Sunucu durumu : %SERVER_STATUS%
) else (
    echo Verification / Server status : %SERVER_STATUS%
)
echo %rustdesk_id%| findstr /r "[^0-9]" >nul
if not errorlevel 1 (
    echo.
    if %LANG_TR%==1 (
        echo Not: Mevcut ID harf/”zel karakter i‡eriyor. Public sunucu bu ID'yi kabul etmez
        echo      ve ba§land§nda otomatik olarak numerik bir ID atar.
    ) else (
        echo Note: The current ID contains letters/custom characters. The Public server
        echo       will not accept it and assigns a numeric ID once connected.
    )
)
call :Log "Switched to Public server"
goto :done
::===============================================================================================================
:Server_Private
echo.
echo $isPrivate = $false > check_private.ps1
echo $hasBackup = $false >> check_private.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> check_private.ps1
echo foreach ^($path in $paths^) { if ^(Test-Path $path^) { $content = Get-Content $path; if ^(^($content -match "^^custom-rendezvous-server"^) -or ^($content -match "^^api-server"^) -or ^($content -match "^^custom-rs-server"^)^) { $isPrivate = $true } } ; if ^(Test-Path "$path.backup"^) { $hasBackup = $true } } >> check_private.ps1
echo if ^($isPrivate^) { exit 1 } elseif ^(-not $hasBackup^) { exit 2 } else { exit 0 } >> check_private.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private.ps1
if errorlevel 2 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Sistemde kaytl bir Private Sunucu yede§i bulunamad.
        echo Ltfen ”nce RustDesk zerinden Private Sunucu bilgilerinizi girip ba§lann.
    ) else (
        echo No Private Server backup found in the system.
        echo Please configure your Private Server in RustDesk first.
    )
    goto :done
)
if errorlevel 1 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Private Sunucu kullanyorsunuz. ˜Ÿlem yaplmad.
    ) else (
        echo You are already using the Private Server. No action taken.
    )
    goto :done
)
del check_private.ps1 >nul 2>&1

echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Server_Private.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_Server_Private.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> RustDesk_Server_Private.ps1
echo foreach ^($path in $paths^) { >> RustDesk_Server_Private.ps1
echo     $backupPath = "$path.backup" >> RustDesk_Server_Private.ps1
echo     if ^(Test-Path $backupPath^) { Copy-Item -Path $backupPath -Destination $path -Force } >> RustDesk_Server_Private.ps1
echo } >> RustDesk_Server_Private.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Private.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Private.ps1
call :RestartGUI
echo.
if %LANG_TR%==1 (
    echo Yedeklenen Private Sunucu ayarlar geri yklendi.
) else (
    echo Backed up Custom Server settings restored.
)
call :GetServerStatus
if %LANG_TR%==1 (
    echo Do§rulama / Sunucu durumu : %SERVER_STATUS%
) else (
    echo Verification / Server status : %SERVER_STATUS%
)
call :Log "Switched to Private server (restored backup)"
goto :done
::===============================================================================================================
:Server_Private_New
echo.
echo $isPrivate = $false > check_private_new.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> check_private_new.ps1
echo foreach ^($path in $paths^) { if ^(Test-Path $path^) { $content = Get-Content $path; if ^(^($content -match "^^custom-rendezvous-server"^) -or ^($content -match "^^api-server"^) -or ^($content -match "^^custom-rs-server"^)^) { $isPrivate = $true } } } >> check_private_new.ps1
echo if ^($isPrivate^) { exit 1 } else { exit 0 } >> check_private_new.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private_new.ps1
if errorlevel 1 (
    del check_private_new.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Private Sunucu zaten yaplandrlmŸ durumda. Ltfen ”nce genel sunucuya ge‡mek ve mevcut ayarlar yedeklemek i‡in 4. se‡ene§i kullann.
    ) else (
        echo A Private Server is already configured. Please use option 4 to switch to Public server first and backup existing settings.
    )
    goto :done
)
del check_private_new.ps1 >nul 2>&1

if %LANG_TR%==1 goto Server_Private_New_TR
goto Server_Private_New_EN

:Server_Private_New_TR
echo Ltfen yeni Private Sunucu (Rendezvous Server) IP veya Host adresini girin.
set /p RS_HOST="Sunucu Adresi (™rn: 192.168.1.100 veya hb.sunucum.com): "
echo.
echo Ltfen Key (Ÿifre) bilgisini girin. E§er key yoksa boŸ brakp ENTER'a basn.
set /p RS_KEY="Key (Opsiyonel): "
goto Server_Private_New_Proceed

:Server_Private_New_EN
echo Please enter the new Private Server (Rendezvous Server) IP or Host address.
set /p RS_HOST="Server Address (e.g. 192.168.1.100 or hb.example.com): "
echo.
echo Please enter the Key. If no key is required, leave blank and press ENTER.
set /p RS_KEY="Key (Optional): "
goto Server_Private_New_Proceed

:Server_Private_New_Proceed
echo.
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Server_Private_New.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_Server_Private_New.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> RustDesk_Server_Private_New.ps1
echo foreach ^($path in $paths^) { >> RustDesk_Server_Private_New.ps1
echo     if ^(Test-Path $path^) { >> RustDesk_Server_Private_New.ps1
echo         $newContent = Get-Content $path >> RustDesk_Server_Private_New.ps1
echo         $newContent = $newContent ^| Where-Object { $_.Trim^(^) -ne "" } >> RustDesk_Server_Private_New.ps1
echo         $newContent += "custom-rendezvous-server = '" + $env:RS_HOST + "'" >> RustDesk_Server_Private_New.ps1
echo         $newContent += "key = '" + $env:RS_KEY + "'" >> RustDesk_Server_Private_New.ps1
echo         $newContent ^| Set-Content $path >> RustDesk_Server_Private_New.ps1
echo     } >> RustDesk_Server_Private_New.ps1
echo } >> RustDesk_Server_Private_New.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Private_New.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Private_New.ps1
call :RestartGUI
echo.
if %LANG_TR%==1 (
    echo Yeni Private Sunucu baŸaryla tanmland ve RustDesk yeniden baŸlatld.
) else (
    echo New Private Server successfully configured and RustDesk restarted.
)
call :GetServerStatus
if %LANG_TR%==1 (
    echo Do§rulama / Sunucu durumu : %SERVER_STATUS%
) else (
    echo Verification / Server status : %SERVER_STATUS%
)
call :Log "New Private server defined"
goto :done
::===============================================================================================================
:Config_Import
echo.
if %LANG_TR%==1 (
    echo RustDesk zerinden dŸa aktard§nz tam yaplandrma dizesini yapŸtrn.
    echo Bu dize ID/Relay/API sunucu ve Key bilgilerinin tamamn i‡erir.
) else (
    echo Paste the full configuration string exported from RustDesk.
    echo This string contains the ID/Relay/API server and Key information.
)
echo.
set "RD_CFG="
set /p RD_CFG="Config String: "
if not defined RD_CFG (
    if %LANG_TR%==1 (
        echo Hata: Config dizesi boŸ olamaz!
    ) else (
        echo Error: Config string cannot be empty!
    )
    goto :done
)
echo $q = [char]34 > RustDesk_Config_Import.ps1
echo $sq = [char]39 >> RustDesk_Config_Import.ps1
echo $shost = ''; $srelay = ''; $sapi = ''; $skey = ''; $dec = '' >> RustDesk_Config_Import.ps1
echo $cfg_str = $env:RD_CFG >> RustDesk_Config_Import.ps1
echo try { $arr = $cfg_str.ToCharArray^(^); [Array]::Reverse^($arr^); $rev = -join $arr; $dec = [System.Text.Encoding]::UTF8.GetString^([Convert]::FromBase64String^($rev^)^) } catch { $dec = '' } >> RustDesk_Config_Import.ps1
echo foreach ^($f in @^('host','relay','api','key'^)^) { $pat = $q + $f + $q + '\s*:\s*' + $q + '^([^^' + $q + ']*^)' + $q; if ^($dec -match $pat^) { Set-Variable -Name ^('s' + $f^) -Value $matches[1] } } >> RustDesk_Config_Import.ps1
echo if ^(-not $shost^) { Write-Host 'INVALID_CONFIG'; exit 4 } >> RustDesk_Config_Import.ps1
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue >> RustDesk_Config_Import.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml","$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> RustDesk_Config_Import.ps1
echo $found = @^($paths ^| Where-Object { Test-Path $_ }^) >> RustDesk_Config_Import.ps1
echo if ^($found.Count -eq 0^) { Write-Host 'CONFIG_NOT_FOUND'; exit 2 } >> RustDesk_Config_Import.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_Config_Import.ps1
echo foreach ^($p in $found^) { $c = Get-Content $p; $c = $c ^| Where-Object { $_ -notmatch '^^\s*custom-rendezvous-server' -and $_ -notmatch '^^\s*custom-rs-server' -and $_ -notmatch '^^\s*relay-server' -and $_ -notmatch '^^\s*api-server' -and $_ -notmatch '^^\s*custom-api-server' -and $_ -notmatch '^^\s*key\s*=' }; $c = @^($c ^| Where-Object { $_.Trim^(^) -ne '' }^); $c += 'custom-rendezvous-server = ' + $sq + $shost + $sq; if ^($srelay^) { $c += 'relay-server = ' + $sq + $srelay + $sq }; if ^($sapi^) { $c += 'api-server = ' + $sq + $sapi + $sq }; $c += 'key = ' + $sq + $skey + $sq; $c ^| Set-Content $p } >> RustDesk_Config_Import.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Config_Import.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File RustDesk_Config_Import.ps1
set "RD_RESULT=%errorlevel%"
if "%RD_RESULT%"=="4" (
    if %LANG_TR%==1 (
        echo Hata: Config dizesi ‡”zmlenemedi. RustDesk'ten dŸa aktarlan ge‡erli bir dize girin.
    ) else (
        echo Error: Could not parse the config string. Enter a valid string exported from RustDesk.
    )
    call :Log "Config import FAILED: invalid string"
    goto :done
)
if "%RD_RESULT%"=="2" (
    if %LANG_TR%==1 (
        echo Hata: RustDesk2.toml bulunamad.
    ) else (
        echo Error: RustDesk2.toml not found.
    )
    call :Log "Config import FAILED: config not found"
    goto :done
)
call :RestartGUI
call :GetServerStatus
echo.
if %LANG_TR%==1 (
    echo Yaplandrma i‡e aktarld ve her iki config dosyasna uyguland.
    echo Do§rulama / Sunucu durumu : %SERVER_STATUS%
) else (
    echo Configuration imported and applied to both config files.
    echo Verification / Server status : %SERVER_STATUS%
)
call :Log "Config string imported, server=%SERVER_STATUS%"
goto :done
::===============================================================================================================
:Set_Password
echo.
setlocal enabledelayedexpansion
if %LANG_TR%==1 (
    echo Kalc eriŸim Ÿifresi en az 6 karakter olmaldr.
) else (
    echo The permanent access password must be at least 6 characters.
)
echo.
:Ask_PW
set "RD_PW="
if %LANG_TR%==1 (
    set /p RD_PW="Yeni žifre: "
) else (
    set /p RD_PW="New Password: "
)
if not defined RD_PW (
    if %LANG_TR%==1 ( echo Hata: žifre boŸ olamaz! ) else ( echo Error: Password cannot be empty! )
    echo.
    goto Ask_PW
)
if "!RD_PW:~5,1!"=="" (
    if %LANG_TR%==1 ( echo Hata: žifre en az 6 karakter olmaldr! ) else ( echo Error: Password must be at least 6 characters! )
    echo.
    goto Ask_PW
)
set "RUSTDESK_EXE=%RUSTDESK_PATH%\rustdesk.exe"
echo ^& $env:RUSTDESK_EXE --password $env:RD_PW > RustDesk_Password.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File RustDesk_Password.ps1
set "RD_RESULT=%errorlevel%"
endlocal & set "RD_RESULT=%RD_RESULT%"
call :RestartGUI
echo.
if "%RD_RESULT%"=="0" (
    if %LANG_TR%==1 (
        echo Do§rulama: Kalc Ÿifre baŸaryla ayarland.
    ) else (
        echo Verification: Permanent password set successfully.
    )
) else (
    if %LANG_TR%==1 (
        echo Uyar: žifre ayarlama komutu hata d”ndrd. RustDesk srmnz kontrol edin.
    ) else (
        echo Warning: The password command returned an error. Check your RustDesk version.
    )
)
call :Log "Permanent password set, result=%RD_RESULT%"
goto :done
::===============================================================================================================
:Reset_PIN
echo.
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Reset_PIN.ps1
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml","$env:APPDATA\RustDesk\config\RustDesk2.toml"^) >> RustDesk_Reset_PIN.ps1
echo $found = @^($paths ^| Where-Object { Test-Path $_ }^) >> RustDesk_Reset_PIN.ps1
echo if ^($found.Count -eq 0^) { Write-Host 'CONFIG_NOT_FOUND'; exit 2 } >> RustDesk_Reset_PIN.ps1
echo $had = $false >> RustDesk_Reset_PIN.ps1
echo foreach ^($p in $found^) { if ^(Get-Content $p ^| Where-Object { $_ -match "^^\s*unlock_pin\s*=" }^) { $had = $true } } >> RustDesk_Reset_PIN.ps1
echo if ^(-not $had^) { Write-Host 'NO_PIN'; exit 3 } >> RustDesk_Reset_PIN.ps1
echo if ^($svc^) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue }; Get-Process rustdesk -ErrorAction SilentlyContinue ^| Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 >> RustDesk_Reset_PIN.ps1
echo foreach ^($p in $found^) { $c = Get-Content $p ^| Where-Object { $_ -notmatch "^^\s*unlock_pin\s*=" }; $c ^| Set-Content $p } >> RustDesk_Reset_PIN.ps1
echo if ^($svc^) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Reset_PIN.ps1
echo exit 0 >> RustDesk_Reset_PIN.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File RustDesk_Reset_PIN.ps1
set "RD_RESULT=%errorlevel%"
if "%RD_RESULT%"=="2" (
    if %LANG_TR%==1 (
        echo Hata: RustDesk2.toml bulunamad.
    ) else (
        echo Error: RustDesk2.toml not found.
    )
    call :Log "Reset unlock_pin FAILED: config not found"
    goto :done
)
if "%RD_RESULT%"=="3" (
    if %LANG_TR%==1 (
        echo AyarlanmŸ bir kilit PIN'i bulunamad. ˜Ÿlem yaplmad.
    ) else (
        echo No settings-lock PIN is set. No action taken.
    )
    call :Log "Reset unlock_pin: no PIN set"
    goto :done
)
call :RestartGUI
echo.
if %LANG_TR%==1 (
    echo Ayarlar kilit PIN'i kaldrld. Yeni bir PIN'i RustDesk arayznden belirleyebilirsiniz.
) else (
    echo Settings-lock PIN removed. You can set a new PIN from the RustDesk interface.
)
call :Log "Settings-lock PIN reset"
goto :done
::===============================================================================================================
:Delete_Backups
echo.
del /f /q "%APPDATA%\RustDesk\config\RustDesk2.toml.backup" >nul 2>&1
del /f /q "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml.backup" >nul 2>&1
if %LANG_TR%==1 (
    echo Private Sunucu yedekleri baŸaryla silindi!
) else (
    echo Custom Server backups deleted successfully!
)
call :Log "Custom server backups deleted"
goto :done
::===============================================================================================================
:done
del RustDesk_ID_Set.ps1 >nul 2>&1
del RustDesk_ID_Restore.ps1 >nul 2>&1
del RustDesk_Server_Public.ps1 >nul 2>&1
del RustDesk_Server_Private.ps1 >nul 2>&1
del RustDesk_Server_Private_New.ps1 >nul 2>&1
del RustDesk_Config_Import.ps1 >nul 2>&1
del RustDesk_Password.ps1 >nul 2>&1
del RustDesk_Reset_PIN.ps1 >nul 2>&1
del detect_path.ps1 >nul 2>&1
del server_status.ps1 >nul 2>&1
echo.
if %LANG_TR%==1 (
    echo	 ˜žLEM TAMAMLANDI
    echo.
    choice /C:MX /N /M "ANA MENš i‡in M, €IKIž i‡in X tuŸuna basn: "
) else (
    echo	 PROCESS COMPLETED
    echo.
    choice /C:MX /N /M "Press M for MAIN MENU -- X for EXIT: "
)
if errorlevel 2 Exit
if errorlevel 1 goto :Main
::===============================================================================================================
:DetectPath
set "RUSTDESK_PATH=C:\Program Files\RustDesk"
echo $p = $null > detect_path.ps1
echo $keys = @^("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk","HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk"^) >> detect_path.ps1
echo foreach ^($k in $keys^) { if ^(Test-Path $k^) { $v = ^(Get-ItemProperty -Path $k -ErrorAction SilentlyContinue^).InstallLocation; if ^($v^) { $p = $v; break } } } >> detect_path.ps1
echo if ^(-not $p^) { $p = "C:\Program Files\RustDesk" } >> detect_path.ps1
echo Write-Output $p.TrimEnd^("\"^) >> detect_path.ps1
for /f "usebackq delims=" %%p in (`powershell -NoProfile -ExecutionPolicy Bypass -File detect_path.ps1`) do set "RUSTDESK_PATH=%%p"
del detect_path.ps1 >nul 2>&1
goto :eof
::===============================================================================================================
:GetServerStatus
set "SERVER_STATUS=Public"
echo $paths = @^("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml","$env:APPDATA\RustDesk\config\RustDesk2.toml"^) > server_status.ps1
echo $srv = "Public" >> server_status.ps1
echo foreach ^($path in $paths^) { if ^(Test-Path $path^) { $line = ^(Get-Content $path ^| Where-Object { $_ -match "^^custom-rendezvous-server" } ^| Select-Object -First 1^); if ^($line^) { $addr = ^(^($line -replace "custom-rendezvous-server\s*=\s*",""^).Trim^(^).Trim^("'"^)^); $srv = "Private [" + $addr + "]"; break } } } >> server_status.ps1
echo Write-Output $srv >> server_status.ps1
for /f "usebackq delims=" %%s in (`powershell -NoProfile -ExecutionPolicy Bypass -File server_status.ps1`) do set "SERVER_STATUS=%%s"
del server_status.ps1 >nul 2>&1
goto :eof
::===============================================================================================================
:RestartGUI
:: Restart only the user-session RustDesk GUI (SessionId != 0) so the app window
:: instantly reflects the new ID/server. The service process (SessionId 0) is left intact.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Process rustdesk -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -ne 0 } | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1
timeout /t 1 >nul 2>&1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
goto :eof
::===============================================================================================================
:Log
>>"%LOGFILE%" echo [%date% %time%] %~1
goto :eof
::===============================================================================================================
