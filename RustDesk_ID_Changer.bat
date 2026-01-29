:: INFO:
:: RustDesk Github: https://github.com/rustdesk/rustdesk

:: RustDesk ID Changer Github: https://github.com/abdullah-erturk/RustDesk-ID-Changer

::===============================================================================================================
@echo off
mode con:cols=90 lines=30
title RustDesk ID Changer by mephistooo2 ^| www.TNCTR.com
net file 1>nul 2>nul && goto :Main || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c ""%~fnx0""""'"
goto :eof
::===============================================================================================================
:Main
cls
if exist "C:\Program Files\RustDesk\rustdesk.exe" (
  cd "C:\Program Files\RustDesk\"
  for /f "delims=" %%i in ('rustdesk.exe --get-id ^| more') do set rustdesk_id=%%i
  goto :Run
  ) else (
  echo.
  echo RustDesk is not installed, install RustDesk first.
  echo.
  echo Press any key to exit.
  pause >nul
  exit
)
:Run
pushd %temp% >nul 2>&1
echo.
echo ==========================================================================================
echo.
echo	  RustDesk ID Changer by mephistooo2 ^| TNCTR.com
echo.
echo	 	  1 - Set RustDesk ID with computer name : "%computername%"
echo.
echo	 	  2 - Set RustDesk ID with 9-digit random numbers
echo.
echo	 	  3 - Set RustDesk ID to the value you specify
echo.
echo	 	  4 - Exit
echo.
echo ==========================================================================================
echo.
choice /c 1234 /cs /n /m "Make Your Choice : "
echo.
if errorlevel 4 Exit
if errorlevel 3 goto :ID_UserDefined
if errorlevel 2 goto :ID_Random
if errorlevel 1 goto :ID_Host
echo.
::===============================================================================================================
:ID_Host
echo.
echo Stop-Service RustDesk > RustDesk_ID_Host.ps1
echo taskkill /im rustdesk.exe /f >> RustDesk_ID_Host.ps1
echo $id = Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" ^| Select-Object -Index 0 >> RustDesk_ID_Host.ps1
echo $hostname = hostname >> RustDesk_ID_Host.ps1
echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_Host.ps1
echo $newId = "id = '$hostname'" >> RustDesk_ID_Host.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_Host.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Host.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_Host.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Host.ps1
echo Restart-Service RustDesk >> RustDesk_ID_Host.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_Host.ps1
start "" "C:\Program Files\RustDesk\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:ID_Random
echo.
echo Stop-Service RustDesk > RustDesk_ID_Random.ps1
echo taskkill /im rustdesk.exe /f >> RustDesk_ID_Random.ps1
echo $randomId = -join ((48..57) ^| Get-Random -Count 9 ^| ForEach-Object {[char]$_}) >> RustDesk_ID_Random.ps1
echo $id = Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" ^| Select-Object -Index 0 >> RustDesk_ID_Random.ps1
echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_Random.ps1
echo $newId = "id = '$randomId'" >> RustDesk_ID_Random.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_Random.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Random.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_Random.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_Random.ps1
echo Restart-Service RustDesk >> RustDesk_ID_Random.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_Random.ps1
start "" "C:\Program Files\RustDesk\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:ID_UserDefined
echo.
echo Stop-Service RustDesk > RustDesk_ID_UserDefined.ps1
echo taskkill /im rustdesk.exe /f >> RustDesk_ID_UserDefined.ps1
echo $id = Get-Content "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" ^| Select-Object -Index 0 >> RustDesk_ID_UserDefined.ps1
echo THE NEW RUSTDESK ID VALUE MUST BE AT LEAST 6 CHARACTERS
timeout /t 2 >nul 2>&1
echo.
echo $newId = Read-Host "Enter RustDesk ID" >> RustDesk_ID_UserDefined.ps1
echo Write-Host "Current ID: %rustdesk_id%" >> RustDesk_ID_UserDefined.ps1
echo $newId = "id = '$newId'" >> RustDesk_ID_UserDefined.ps1
echo Write-Host "New ID: $newId" >> RustDesk_ID_UserDefined.ps1
echo $fileContent = Get-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_UserDefined.ps1
echo $newContent = $fileContent -replace [regex]::Escape($id), $newId >> RustDesk_ID_UserDefined.ps1
echo $newContent ^| Set-Content -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk.toml" >> RustDesk_ID_UserDefined.ps1
echo Restart-Service RustDesk >> RustDesk_ID_UserDefined.ps1
powershell.exe -ExecutionPolicy Bypass -File RustDesk_ID_UserDefined.ps1
start "" "C:\Program Files\RustDesk\rustdesk.exe" --tray
goto :done
::===============================================================================================================
:done
del RustDesk_ID_Host.ps1 >nul 2>&1
del RustDesk_ID_Random.ps1 >nul 2>&1
del RustDesk_ID_UserDefined.ps1 >nul 2>&1
echo.
echo	 PROCESS COMPLETED
echo.
choice /C:MX /N /M "Press M for MAIN MENU -- X for EXIT: "
if errorlevel 2 Exit
if errorlevel 1 goto :Main
::===============================================================================================================
