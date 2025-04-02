@echo off
setlocal enabledelayedexpansion

REM Define the path to the 7z executable
set "7zPath=C:\Program Files\PeaZip\res\bin\7z\7z.exe"

REM Define the output directory for extracted files
set "outputDir=C:\Users\%USERNAME%\Downloads\NewFolder"

REM Define the path to the keywords file
set "keywordsFile=keywords.txt"

REM Define the path to the passwords file
set "passwordsFile=passwords.txt"

REM Define the path to the files list
set "filesList=files.txt"

REM Function to extract files
:extract_files
    set "rarFile=%1"
    set "keyword=%2"
    set "password=%3"
    if "%password%"=="" (
        "%7zPath%" x "%rarFile%" -aos -o"%outputDir%" -bb0 -bse0 -bsp2 -sccUTF-8 -snz -r -- %keyword%
    ) else (
        "%7zPath%" x "%rarFile%" -aos -o"%outputDir%" -bb0 -bse0 -bsp2 -p%password% -sccUTF-8 -snz -r -- %keyword%
    )
    if !errorlevel! neq 0 (
        echo Extraction failed for %rarFile% with password %password%
        exit /b 1
    )
    exit /b 0
)

REM Loop through each file in files.txt
for /f "delims=" %%f in (%filesList%) do (
    REM Loop through each keyword in keywords.txt
    for /f "delims=" %%k in (%keywordsFile%) do (
        set "keyword=%%k"
        
        REM Try extracting without a password first
        echo Processing %%f with keyword !keyword! and attempting without password
        call :extract_files "%%f" "!keyword!" ""
        if !errorlevel! neq 0 (
            REM Loop through each password in passwords.txt if extraction without password fails
            for /f "delims=" %%p in (%passwordsFile%) do (
                set "password=%%p"
                echo Attempting extraction of %%f with keyword !keyword! and password !password!
                call :extract_files "%%f" "!keyword!" "!password!"
                if !errorlevel! eq 0 (
                    echo Successfully extracted %%f with password !password!
                    goto :keyword_next
                )
            )
        ) else (
            echo Successfully extracted %%f without any password!
        )
        :keyword_next
    )
    
    REM Delete the processed RAR file and extracted folder
    echo Deleting processed RAR file %%f
    del "%%f"
    echo Deleting extracted folder %%~nf
    rmdir /s /q "%outputDir%\%%~nf"
)

echo Extraction process completed.
endlocal
pause
