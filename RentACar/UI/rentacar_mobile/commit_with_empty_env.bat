@echo off
setlocal enabledelayedexpansion

REM Write empty values to the .env file
echo const stripePublishableKey=""; > "C:\Rent-a-car\RentACar\UI\rentacar_mobile\lib\.env"
echo const secretKey=""; >> "C:\Rent-a-car\RentACar\UI\rentacar_mobile\lib\.env"

REM Commit changes using GitHub Desktop command line
REM Adjust the path to GitHub Desktop CLI as necessary
"C:\Users\Dzenan\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\GitHub, Inc\GitHub Desktop.lnk" /command:create-branch-and-checkout /path:"C:\path\to\your\repository"

echo Commit completed with empty .env values!
pause
