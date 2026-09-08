
	:: INFO:
	:: RustDesk Github: https://github.com/rustdesk/rustdesk
	:: RustDesk ID Changer Github: https://github.com/abdullah-erturk/RustDesk-ID-Changer

::===============================================================================================================
@echo off
mode con:cols=90 lines=45
title RustDesk ID ^& Server Changer v3 by Abdullah ERTöRK

:: Language check via Get-UICulture (Display Language)
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-UICulture).TwoLetterISOLanguageName"') do set OS_LANG=%%a
set LANG_TR=0
if /i "%OS_LANG%"=="tr" set LANG_TR=1

net file 1>nul 2>nul && goto :Main || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c ""%~fnx0""""'"
goto :eof
::===============================================================================================================
:Main
cls

set "RUSTDESK_PATH=C:\Program Files\RustDesk"

if exist "%RUSTDESK_PATH%\rustdesk.exe" (
  cd /d "%RUSTDESK_PATH%"
  for /f "delims=" %%i in ('rustdesk.exe --get-id ^| more') do set rustdesk_id=%%i
  goto :Run
) else (
echo.
if %LANG_TR%==1 (
echo RustDesk kurulu deßil, înce RustDesk'i kurun.
echo.
echo Äçkçü iáin herhangi bir tuüa basçn.
) else (
echo RustDesk is not installed, install RustDesk first.
echo.
echo Press any key to exit.
)
pause >nul
exit
)
:Run
pushd %temp% >nul 2>&1
echo.
echo ==========================================================================================
echo.
if %LANG_TR%==1 goto Menu_TR
goto Menu_EN

:Menu_TR
echo			  RustDesk ID ^& Server Changer by Abdullah ERTöRK
echo.
echo.		github.com/abdullah-erturk ^| erturk-dev.netlify.app
echo.
echo.
echo	 	  1 - RustDesk ID'sini bilgisayar adçyla deßistir : "%computername%"
echo.
echo	 	  2 - RustDesk ID'sini 9 haneli rastgele sayçlarla deßistir
echo.
echo	 	  3 - RustDesk ID'sini belirttißiniz deßere ayarlayçn.
echo.
echo.	-----------------------------------------------------------------
echo.
echo	 	  4 - Public Sunucuya Geá (Private Sunucu Bilgisini Temizle)
echo.
echo	 	  5 - Private Sunucuya Geá (Private Sunucu Bilgisini Uygula)
echo.
echo	 	  6 - Yeni Private Sunucu Tançmla 
echo.
echo	 	  7 - Private Sunucu Yedeklerini Sil 
echo.
echo	 	  8 - ÄIKIû
echo.
echo ==========================================================================================
echo.
choice /c 12345678 /cs /n /m "Seáiminiz [1-2-3-4-5-6-7-8] : "
goto Menu_Choice

:Menu_EN
echo			  RustDesk ID ^& Server Changer by Abdullah ERTURK
echo.
echo.		github.com/abdullah-erturk ^| erturk-dev.netlify.app
echo.
echo.
echo	 	  1 - Set RustDesk ID with computer name : "%computername%"
echo.
echo	 	  2 - Set RustDesk ID with 9-digit random numbers
echo.
echo	 	  3 - Set RustDesk ID to the value you specify
echo.
echo.	-----------------------------------------------------------------
echo.
echo	 	  4 - Set Public Server (Clear Custom Server Info)
echo.
echo	 	  5 - Set Private Server (Apply Custom Server Info)
echo.
echo	 	  6 - Set New Private Server
echo.
echo	 	  7 - Delete Custom Server Backups
echo.
echo	 	  8 - Exit
echo.
echo ==========================================================================================
echo.
choice /c 12345678 /cs /n /m "Your Choice [1-2-3-4-5-6-7-8] : "
goto Menu_Choice

:Menu_Choice
echo.
if errorlevel 8 Exit
if errorlevel 7 goto :Delete_Backups
if errorlevel 6 goto :Server_Private_New
if errorlevel 5 goto :Server_Private
if errorlevel 4 goto :Server_Public
if errorlevel 3 goto :ID_UserDefined
if errorlevel 2 goto :ID_Random
if errorlevel 1 goto :ID_Host
echo.
::===============================================================================================================
:ID_Host
echo.
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_ID_Host.ps1
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_Host.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_Host.ps1
echo $id = ^(Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml"^)[0] >> RustDesk_ID_Host.ps1
echo $hostname = hostname >> RustDesk_ID_Host.ps1
echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_Host.ps1
echo $newId = "id = '$hostname'" >> RustDesk_ID_Host.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_Host.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Host.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_Host.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Host.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_ID_Host.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_Host.ps1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:ID_Random
echo.
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_ID_Random.ps1
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_Random.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_Random.ps1
echo $randomId = -join ((48..57) ^| Get-Random -Count 9 ^| ForEach-Object {[char]$_}) >> RustDesk_ID_Random.ps1
echo $id = ^(Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml"^)[0] >> RustDesk_ID_Random.ps1
echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_Random.ps1
echo $newId = "id = '$randomId'" >> RustDesk_ID_Random.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_Random.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Random.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_Random.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Random.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_ID_Random.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_Random.ps1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:ID_UserDefined
echo.
  ver | findstr /c:"Version 10." >nul
  if errorlevel 1 (
      if %LANG_TR%==1 (
          echo Hata: Bu seáenek sadece Windows 10 ve Åzeri sÅrÅmlerde desteklenmektedir!
      ) else (
          echo Error: This option is only supported on Windows 10 and later!
      )
      timeout /t 5 >nul
      goto :Main
  )
echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_ID_UserDefined.ps1
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_UserDefined.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_ID_UserDefined.ps1
echo $id = ^(Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml"^)[0] >> RustDesk_ID_UserDefined.ps1
  if %LANG_TR%==1 (
  echo YENI RUSTDESK ID DEGERI EN AZ 6 KARAKTER OLMALIDIR
  timeout /t 2 >nul 2>&1
  echo.
  goto Ask_ID_TR
  ) else (
  echo THE NEW RUSTDESK ID VALUE MUST BE AT LEAST 6 CHARACTERS
  timeout /t 2 >nul 2>&1
  echo.
  goto Ask_ID_EN
  )

:Ask_ID_TR
set "RUSTDESK_NEW_ID="
set /p RUSTDESK_NEW_ID="RustDesk ID Girin (En az 6 karakter): "
if not defined RUSTDESK_NEW_ID (
    echo Hata: ID bos olamaz!
    echo.
    goto Ask_ID_TR
)
if "%RUSTDESK_NEW_ID:~5,1%"=="" (
    echo Hata: ID en az 6 karakter olmalidir!
    echo.
    goto Ask_ID_TR
)
goto ID_UserDefined_Continue

:Ask_ID_EN
set "RUSTDESK_NEW_ID="
set /p RUSTDESK_NEW_ID="Enter RustDesk ID (At least 6 characters): "
if not defined RUSTDESK_NEW_ID (
    echo Error: ID cannot be empty!
    echo.
    goto Ask_ID_EN
)
if "%RUSTDESK_NEW_ID:~5,1%"=="" (
    echo Error: ID must be at least 6 characters!
    echo.
    goto Ask_ID_EN
)
goto ID_UserDefined_Continue

:ID_UserDefined_Continue
  echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_UserDefined.ps1
  echo $newId = "id = '%RUSTDESK_NEW_ID%'" >> RustDesk_ID_UserDefined.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_UserDefined.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_UserDefined.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_UserDefined.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_UserDefined.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_ID_UserDefined.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_UserDefined.ps1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:Server_Public
echo.
echo $isPublic = $true > check_public.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> check_public.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPublic = $false } } } >> check_public.ps1
echo if ($isPublic) { exit 1 } else { exit 0 } >> check_public.ps1
powershell.exe -ExecutionPolicy Bypass -File check_public.ps1
if errorlevel 1 (
    del check_public.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Public Sunucu kullançyorsunuz. òülem yapçlmadç.
    ) else (
        echo You are already using the Public Server. No action taken.
    )
    goto :done
)
del check_public.ps1 >nul 2>&1

echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Server_Public.ps1
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Public.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Public.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> RustDesk_Server_Public.ps1
echo foreach ($path in $paths) { >> RustDesk_Server_Public.ps1
echo     if (Test-Path $path) { >> RustDesk_Server_Public.ps1
echo         $content = Get-Content $path >> RustDesk_Server_Public.ps1
echo         $hasCustom = ($content -match "^custom-rendezvous-server" -or $content -match "^api-server" -or $content -match "^custom-rs-server") >> RustDesk_Server_Public.ps1
echo         if ($hasCustom) { Copy-Item -Path $path -Destination "$path.backup" -Force; if (-not (Test-Path "$path.backup")) { exit 3 } } >> RustDesk_Server_Public.ps1
echo         $newContent = $content -replace "^custom-rendezvous-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^custom-rs-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^api-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^custom-api-server.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent -replace "^key.*", "" >> RustDesk_Server_Public.ps1
echo         $newContent = $newContent ^| Where-Object { $_.Trim() -ne "" } >> RustDesk_Server_Public.ps1
echo         $newContent ^| Set-Content $path >> RustDesk_Server_Public.ps1
echo     } >> RustDesk_Server_Public.ps1
echo } >> RustDesk_Server_Public.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Public.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Public.ps1
if errorlevel 3 (
    if %LANG_TR%==1 (
        echo Yedekleme sçrasçnda bir hata olustu. òzinleri kontrol edin. òüleme devam edilemedi.
    ) else (
        echo An error occurred during backup. Check permissions. Process aborted.
    )
    goto :done
)
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
echo.
if %LANG_TR%==1 (
echo Mevcut private sunucu ayarlarç yedeklendi ve Public sunucuya geáildi.
) else (
echo Current custom server settings backed up and switched to Public server.
)
goto :done
::===============================================================================================================
:Server_Private
echo.
echo $isPrivate = $false > check_private.ps1
echo $hasBackup = $false >> check_private.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> check_private.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPrivate = $true } } ; if (Test-Path "$path.backup") { $hasBackup = $true } } >> check_private.ps1
echo if ($isPrivate) { exit 1 } elseif (-not $hasBackup) { exit 2 } else { exit 0 } >> check_private.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private.ps1
if errorlevel 2 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Sistemde kayçtlç bir Private Sunucu yedeßi bulunamadç.
        echo LÅtfen înce RustDesk Åzerinden Private Sunucu bilgilerinizi girip baßlançn.
    ) else (
        echo No Private Server backup found in the system.
        echo Please configure your Private Server in RustDesk first.
    )
    goto :done
)
if errorlevel 1 (
    del check_private.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Zaten Private Sunucu kullançyorsunuz. òülem yapçlmadç.
    ) else (
        echo You are already using the Private Server. No action taken.
    )
    goto :done
)
del check_private.ps1 >nul 2>&1

echo $svc = Get-Service -Name RustDesk -ErrorAction SilentlyContinue > RustDesk_Server_Private.ps1
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Private.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Private.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> RustDesk_Server_Private.ps1
echo foreach ($path in $paths) { >> RustDesk_Server_Private.ps1
echo     $backupPath = "$path.backup" >> RustDesk_Server_Private.ps1
echo     if (Test-Path $backupPath) { Copy-Item -Path $backupPath -Destination $path -Force } >> RustDesk_Server_Private.ps1
echo } >> RustDesk_Server_Private.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Private.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Private.ps1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
echo.
if %LANG_TR%==1 (
echo Yedeklenen Private Sunucu ayarlarç geri yÅklendi.
) else (
echo Backed up Custom Server settings restored.
)
goto :done
::===============================================================================================================
:Server_Private_New
echo.
echo $isPrivate = $false > check_private_new.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> check_private_new.ps1
echo foreach ($path in $paths) { if (Test-Path $path) { $content = Get-Content $path; if (($content -match "^custom-rendezvous-server") -or ($content -match "^api-server") -or ($content -match "^custom-rs-server")) { $isPrivate = $true } } } >> check_private_new.ps1
echo if ($isPrivate) { exit 1 } else { exit 0 } >> check_private_new.ps1
powershell.exe -ExecutionPolicy Bypass -File check_private_new.ps1
if errorlevel 1 (
    del check_private_new.ps1 >nul 2>&1
    if %LANG_TR%==1 (
        echo Private Sunucu zaten yapçlandçrçlmçü durumda. LÅtfen înce genel sunucuya geámek ve mevcut ayarlarç yedeklemek iáin 4. seáeneßi kullançn.
    ) else (
        echo A Private Server is already configured. Please use option 4 to switch to Public server first and backup existing settings.
    )
    goto :done
)
del check_private_new.ps1 >nul 2>&1

if %LANG_TR%==1 goto Server_Private_New_TR
goto Server_Private_New_EN

:Server_Private_New_TR
echo LÅtfen yeni Private Sunucu (Rendezvous Server) IP veya Host adresini girin.
set /p RS_HOST="Sunucu Adresi (Orn: 192.168.1.100 veya hb.sunucum.com): "
echo.
echo LÅtfen Key (ûifre) bilgisini girin. Eßer key yoksa bos bçrakçp ENTER'a basin.
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
echo if ($svc) { Stop-Service -Name RustDesk -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Private_New.ps1
echo else { Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 1 } >> RustDesk_Server_Private_New.ps1
echo $paths = @("C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml", "$env:APPDATA\RustDesk\config\RustDesk2.toml") >> RustDesk_Server_Private_New.ps1
echo foreach ($path in $paths) { >> RustDesk_Server_Private_New.ps1
echo     if (Test-Path $path) { >> RustDesk_Server_Private_New.ps1
echo         $newContent = Get-Content $path >> RustDesk_Server_Private_New.ps1
echo         $newContent = $newContent ^| Where-Object { $_.Trim() -ne "" } >> RustDesk_Server_Private_New.ps1
echo         $newContent += "custom-rendezvous-server = '%RS_HOST%'" >> RustDesk_Server_Private_New.ps1
echo         $newContent += "key = '%RS_KEY%'" >> RustDesk_Server_Private_New.ps1

echo         $newContent ^| Set-Content $path >> RustDesk_Server_Private_New.ps1
echo     } >> RustDesk_Server_Private_New.ps1
echo } >> RustDesk_Server_Private_New.ps1
echo if ($svc) { Start-Service -Name RustDesk -ErrorAction SilentlyContinue } >> RustDesk_Server_Private_New.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_Server_Private_New.ps1
start "" "%RUSTDESK_PATH%\rustdesk.exe" --tray
echo.
if %LANG_TR%==1 (
echo Yeni Private Sunucu baüarçyla tançmlandç ve RustDesk yeniden baülatçldç.
) else (
echo New Private Server successfully configured and RustDesk restarted.
)
goto :done
::===============================================================================================================
:Delete_Backups
echo.
del /f /q "%APPDATA%\RustDesk\config\RustDesk2.toml.backup" >nul 2>&1
del /f /q "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml.backup" >nul 2>&1
if %LANG_TR%==1 (
echo Private Sunucu yedekleri baüarçyla silindi!
) else (
echo Custom Server backups deleted successfully!
)
goto :done
::===============================================================================================================
:done
del RustDesk_ID_Host.ps1 >nul 2>&1
del RustDesk_ID_Random.ps1 >nul 2>&1
del RustDesk_ID_UserDefined.ps1 >nul 2>&1
del RustDesk_Server_Public.ps1 >nul 2>&1
del RustDesk_Server_Private.ps1 >nul 2>&1
del RustDesk_Server_Private_New.ps1 >nul 2>&1
echo.
if %LANG_TR%==1 (
echo	 òûLEM TAMAMLANDI
echo.
choice /C:MX /N /M "ANA MENö icin M, ÄIKIû icin X tuüuna basçn: "
) else (
echo	 PROCESS COMPLETED
echo.
choice /C:MX /N /M "Press M for MAIN MENU -- X for EXIT: "
)
if errorlevel 2 Exit
if errorlevel 1 goto :Main
::===============================================================================================================