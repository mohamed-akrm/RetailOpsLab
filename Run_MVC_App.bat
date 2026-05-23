@echo off
cd /d "%~dp0web\RetailOpsLab"
dotnet restore
dotnet run
pause
