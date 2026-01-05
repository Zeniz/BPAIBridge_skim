@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ANSI 색상 코드 설정 (Windows 10+)
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RED=%ESC%[31m"
set "CYAN=%ESC%[36m"
set "RESET=%ESC%[0m"

echo ========================================
echo %CYAN%BPAIBridge Lite -^> Full 변환%RESET%
echo ========================================
echo.
echo 이 스크립트는 PyPI에서 wheel 패키지를 다운로드하여
echo Lite 버전을 Full 버전(오프라인 설치 가능)으로 변환합니다.
echo.

set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
set WHEELS_DIR=%SCRIPT_DIR%\ue_plugin\BPAIBridge\mcp\wheels
set MCP_DIR=%SCRIPT_DIR%\ue_plugin\BPAIBridge\mcp

REM Python 찾기
set PYTHON_CMD=

where python >nul 2>&1
if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        "%%i" --version >nul 2>&1
        if !errorlevel! equ 0 (
            set PYTHON_CMD="%%i"
            goto :PYTHON_FOUND
        )
    )
)

where py >nul 2>&1
if !errorlevel! equ 0 (
    py --version >nul 2>&1
    if !errorlevel! equ 0 (
        set PYTHON_CMD=py
        goto :PYTHON_FOUND
    )
)

for %%P in (
    "%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
    "%LOCALAPPDATA%\Programs\Python\Python310\python.exe"
) do (
    if exist %%P (
        set PYTHON_CMD=%%P
        goto :PYTHON_FOUND
    )
)

echo %RED%[오류]%RESET% Python이 설치되지 않았습니다.
pause
exit /b 1

:PYTHON_FOUND
echo %GREEN%Python 발견:%RESET%
%PYTHON_CMD% --version

echo.
echo ----------------------------------------
echo 네트워크 연결 확인
echo ----------------------------------------
ping -n 1 pypi.org >nul 2>&1
if !errorlevel! neq 0 (
    echo %RED%[오류]%RESET% PyPI에 접속할 수 없습니다.
    echo        인터넷 연결을 확인하세요.
    pause
    exit /b 1
)
echo %GREEN%[성공]%RESET% PyPI 접속 가능

echo.
echo ----------------------------------------
echo wheels 폴더 생성
echo ----------------------------------------
if exist "%WHEELS_DIR%" (
    echo 기존 wheels 폴더 삭제 중...
    rmdir /s /q "%WHEELS_DIR%"
)
mkdir "%WHEELS_DIR%"
echo 생성됨: %WHEELS_DIR%

echo.
echo ----------------------------------------
echo wheel 패키지 다운로드 중...
echo ----------------------------------------
echo 이 작업은 몇 분 정도 소요될 수 있습니다.
echo.

cd /d "%MCP_DIR%"
%PYTHON_CMD% -m pip download -r requirements.txt -d "%WHEELS_DIR%"

if !errorlevel! neq 0 (
    echo.
    echo %RED%[오류]%RESET% wheel 다운로드에 실패했습니다.
    pause
    exit /b 1
)

echo.
echo ----------------------------------------
echo 다운로드 결과 확인
echo ----------------------------------------
set WHEEL_COUNT=0
for %%f in ("%WHEELS_DIR%\*.whl") do set /a WHEEL_COUNT+=1

echo 다운로드된 패키지: %WHEEL_COUNT%개

if %WHEEL_COUNT% LSS 10 (
    echo %YELLOW%[경고]%RESET% 다운로드된 패키지가 예상보다 적습니다.
) else (
    echo %GREEN%[성공]%RESET% wheel 패키지 다운로드 완료
)

echo.
echo ========================================
echo %GREEN%변환 완료!%RESET%
echo ========================================
echo.
echo Lite 버전이 Full 버전으로 변환되었습니다.
echo 이제 오프라인 환경에서도 02_install.bat을 실행할 수 있습니다.
echo.
echo wheels 폴더 위치: %WHEELS_DIR%
echo.
pause
