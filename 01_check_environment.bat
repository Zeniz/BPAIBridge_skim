@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ANSI 색상 코드 설정 (Windows 10+)
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

echo ========================================
echo BPAIBridge 환경 체크
echo ========================================
echo.

set HAS_ERROR=0
set PYTHON_CMD=
set PYTHON_PATH=

REM Python 체크 - 여러 방법으로 시도
echo [체크] Python 설치 여부...

REM 1. PATH에서 python 시도
where python >nul 2>&1
if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        set PYTHON_PATH=%%i
        "%%i" --version >nul 2>&1
        if !errorlevel! equ 0 (
            set PYTHON_CMD="%%i"
            for /f "tokens=2" %%v in ('"%%i" --version 2^>^&1') do echo   %GREEN%[성공]%RESET% Python %%v
            goto :CHECK_PIP
        )
    )
)

REM 2. py launcher 시도
where py >nul 2>&1
if !errorlevel! equ 0 (
    py --version >nul 2>&1
    if !errorlevel! equ 0 (
        set PYTHON_CMD=py
        for /f "tokens=2" %%v in ('py --version 2^>^&1') do echo   %GREEN%[성공]%RESET% Python %%v (py launcher)
        goto :CHECK_PIP
    )
)

REM 3. 일반적인 설치 경로 검색
for %%P in (
    "%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python310\python.exe"
    "%PROGRAMFILES%\Python313\python.exe"
    "%PROGRAMFILES%\Python312\python.exe"
    "%PROGRAMFILES%\Python311\python.exe"
    "%PROGRAMFILES%\Python310\python.exe"
    "C:\Python313\python.exe"
    "C:\Python312\python.exe"
    "C:\Python311\python.exe"
    "C:\Python310\python.exe"
) do (
    if exist %%P (
        %%P --version >nul 2>&1
        if !errorlevel! equ 0 (
            set PYTHON_CMD=%%P
            for /f "tokens=2" %%v in ('%%P --version 2^>^&1') do echo   %GREEN%[성공]%RESET% Python %%v
            echo          경로: %%~P
            goto :CHECK_PIP
        )
    )
)

REM Python을 찾지 못함
echo   %RED%[실패]%RESET% Python이 설치되지 않았습니다.
echo          다운로드: https://www.python.org/downloads/
echo          ※ 설치 시 "Add Python to PATH" 옵션을 체크하세요.
set HAS_ERROR=1

:CHECK_PIP
echo [체크] pip 설치 여부...
if not defined PYTHON_CMD (
    echo   %YELLOW%[건너뜀]%RESET% Python이 없어 pip 체크 불가
    goto :CHECK_CLAUDE
)

%PYTHON_CMD% -m pip --version >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% pip 설치됨
) else (
    echo   %RED%[실패]%RESET% pip이 설치되지 않았습니다.
    set HAS_ERROR=1
)

:CHECK_CLAUDE
echo [체크] Claude Code 설치 여부...
where claude >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% Claude Code 설치됨
) else (
    echo   %YELLOW%[경고]%RESET% Claude Code가 설치되지 않았습니다.
    echo          설치: npm install -g @anthropic-ai/claude-code
)

:CHECK_NETWORK
echo [체크] 외부망 접속 (pypi.org) - pip 설치용...
ping -n 1 pypi.org >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% 네트워크 연결 확인됨 - 온라인 설치 가능
) else (
    echo   %YELLOW%[경고]%RESET% pypi.org에 접속할 수 없습니다. (폐쇄망/오프라인)
    echo          wheels 폴더가 포함된 버전이라면 오프라인 설치가 가능합니다.
)

echo [체크] 외부망 접속 (api.anthropic.com) - Claude Code용...
ping -n 1 api.anthropic.com >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% Anthropic API 접속 가능 - Claude Code 사용 가능
) else (
    echo   %YELLOW%[경고]%RESET% api.anthropic.com에 접속할 수 없습니다.
    echo          Claude Code 사용이 불가능합니다.
)

echo [체크] 외부망 접속 (api.cursor.com) - Cursor용...
ping -n 1 api.cursor.com >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% Cursor API 접속 가능 - Cursor 사용 가능
) else (
    echo   %YELLOW%[경고]%RESET% api.cursor.com에 접속할 수 없습니다.
    echo          Cursor 사용이 불가능합니다.
)

echo [체크] 외부망 접속 (generativelanguage.googleapis.com) - Gemini CLI용...
ping -n 1 generativelanguage.googleapis.com >nul 2>&1
if !errorlevel! equ 0 (
    echo   %GREEN%[성공]%RESET% Google AI API 접속 가능 - Gemini CLI 사용 가능
) else (
    echo   %YELLOW%[경고]%RESET% generativelanguage.googleapis.com에 접속할 수 없습니다.
    echo          Gemini CLI 사용이 불가능합니다.
)

echo.
echo ========================================
if !HAS_ERROR!==1 (
    echo %RED%필수 요구사항이 충족되지 않았습니다.%RESET%
    echo 위의 [실패] 항목을 해결한 후 다시 실행하세요.
) else (
    echo %GREEN%환경 체크 완료!%RESET% 02_install.bat을 실행하세요.
)
echo ========================================
pause
