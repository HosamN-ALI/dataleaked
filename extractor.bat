@echo off
setlocal enabledelayedexpansion

REM Set the number of threads to the maximum available
set "max_threads=80"

REM Set the command template (Replace with your actual command, escaping special characters as needed)
set "command_template=C:\Program Files\PeaZip\res\bin\7z\7z.exe x -aos -oC:\Users\Administrator\Downloads\New folder -bb0 -bse0 -bsp2 -ppassword -sccUTF-8 -snz %%filename%% -r -- *password*.txt"

REM Read file names from filenames.txt and run the command for each file
for /f "tokens=*" %%i in (filenames.txt) do (
    set "filename=%%i"
    echo Running command for !filename!
    set "command=!command_template:%%filename%%=!filename!!"
    !command!
)

echo All commands executed.
pause
