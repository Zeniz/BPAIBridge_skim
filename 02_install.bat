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
echo %CYAN%BPAIBridge 설치%RESET%
echo ========================================
echo.

set INSTALLER_DIR=%~dp0
set INSTALLER_DIR=%INSTALLER_DIR:~0,-1%

REM Python 찾기
set PYTHON_CMD=

REM 1. PATH에서 python 시도
where python >nul 2>&1
if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        "%%i" --version >nul 2>&1
        if !errorlevel! equ 0 (
            set PYTHON_CMD="%%i"
            echo %GREEN%Python 발견:%RESET% %%i
            goto :PYTHON_FOUND
        )
    )
)

REM 2. py launcher 시도
where py >nul 2>&1
if !errorlevel! equ 0 (
    py --version >nul 2>&1
    if !errorlevel! equ 0 (
        set PYTHON_CMD=py
        echo %GREEN%Python 발견:%RESET% py launcher
        goto :PYTHON_FOUND
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
            echo %GREEN%Python 발견:%RESET% %%~P
            goto :PYTHON_FOUND
        )
    )
)

REM Python을 찾지 못함
echo %RED%[오류]%RESET% Python이 설치되지 않았습니다.
echo        https://www.python.org/downloads/ 에서 설치하세요.
pause
exit /b 1

:PYTHON_FOUND
%PYTHON_CMD% --version

echo.
echo ----------------------------------------
echo [필수 입력] UE 프로젝트 경로
echo ----------------------------------------
echo BPAIBridge를 설치할 언리얼 프로젝트의 루트 폴더를 입력하세요.
echo (Plugins 폴더가 있는 상위 폴더)
echo.
echo 예시: D:\MyProject
echo       C:\Users\Username\Documents\Unreal Projects\MyGame
echo.
set /p PROJECT_PATH=프로젝트 경로:

REM 경로 끝의 백슬래시 제거
if "%PROJECT_PATH:~-1%"=="\" set PROJECT_PATH=%PROJECT_PATH:~0,-1%

REM 경로 유효성 체크
if not exist "%PROJECT_PATH%" (
    echo.
    echo %RED%[오류]%RESET% 경로가 존재하지 않습니다: %PROJECT_PATH%
    pause
    exit /b 1
)

REM Plugins 폴더 체크/생성
if not exist "%PROJECT_PATH%\Plugins" (
    echo Plugins 폴더가 없습니다. 생성합니다...
    mkdir "%PROJECT_PATH%\Plugins"
)

set PLUGIN_DEST=%PROJECT_PATH%\Plugins\BPAIBridge
set MCP_DIR=%PLUGIN_DEST%\mcp

echo.
echo ========================================
echo %CYAN%1. BPAIBridge 플러그인 복사 중...%RESET%
echo ========================================
echo 대상: %PLUGIN_DEST%

if exist "%PLUGIN_DEST%" (
    echo 기존 폴더 삭제 중...
    rmdir /s /q "%PLUGIN_DEST%"
)

xcopy /E /I /Y "%INSTALLER_DIR%\ue_plugin\BPAIBridge" "%PLUGIN_DEST%"

echo.
echo ========================================
echo %CYAN%2. Python 가상환경 생성 중...%RESET%
echo ========================================
cd /d "%MCP_DIR%"
%PYTHON_CMD% -m venv venv

if not exist "venv\Scripts\python.exe" (
    echo %RED%[오류]%RESET% 가상환경 생성에 실패했습니다.
    pause
    exit /b 1
)

echo.
echo ========================================
echo %CYAN%3. 의존성 설치 중...%RESET%
echo ========================================
call venv\Scripts\activate.bat
python -m pip install --upgrade pip >nul 2>&1

REM 외부망 접속 체크
echo 외부망(PyPI) 접속 확인 중...
ping -n 1 pypi.org >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%[온라인 모드]%RESET% PyPI에서 패키지 다운로드 중...
    pip install -r requirements.txt
    if !errorlevel! neq 0 (
        echo.
        echo %YELLOW%[경고]%RESET% 온라인 설치 실패. 오프라인 모드로 재시도합니다...
        goto :OFFLINE_INSTALL
    )
) else (
    echo %YELLOW%[오프라인 모드]%RESET% 미리 포함된 패키지로 설치 중...
    goto :OFFLINE_INSTALL
)
goto :INSTALL_PACKAGE

:OFFLINE_INSTALL
if exist "wheels" (
    pip install --no-index --find-links=wheels -r requirements.txt
    if !errorlevel! neq 0 (
        echo.
        echo %RED%[오류]%RESET% 오프라인 설치에 실패했습니다.
        echo        wheels 폴더의 패키지가 Python 버전과 호환되는지 확인하세요.
        pause
        exit /b 1
    )
) else (
    echo.
    echo %RED%[오류]%RESET% wheels 폴더가 없습니다. 오프라인 설치를 할 수 없습니다.
    echo        외부망 연결이 필요합니다.
    pause
    exit /b 1
)

:INSTALL_PACKAGE
echo.
echo 패키지 설치 중...
pip install -e . --no-deps
if !errorlevel! neq 0 (
    echo %RED%[오류]%RESET% 패키지 설치에 실패했습니다.
    pause
    exit /b 1
)

echo.
echo ========================================
echo %GREEN%설치 완료!%RESET%
echo ========================================
echo.
echo 설치 위치: %PLUGIN_DEST%
echo.
echo ========================================
echo %YELLOW%[중요] UE 프로젝트 빌드 필요!%RESET%
echo ========================================
echo.
echo C++ 플러그인이 추가되었으므로 프로젝트를 다시 빌드해야 합니다.
echo.
echo 방법 1: Visual Studio 사용
echo   1. %PROJECT_PATH%\프로젝트이름.sln 파일 열기
echo   2. 빌드 ^> 솔루션 빌드 (Ctrl+Shift+B)
echo.
echo 방법 2: GenerateProjectFiles 사용
echo   1. %PROJECT_PATH%\GenerateProjectFiles.bat 실행
echo   2. Visual Studio에서 빌드
echo.
echo 방법 3: Editor에서 직접 빌드
echo   1. Unreal Editor 실행
echo   2. 플러그인 빌드 프롬프트가 나타나면 Yes 클릭
echo.
echo ========================================
echo.
echo 다음 단계:
echo 1. [필수] UE 프로젝트 빌드
echo 2. 03_setup_mcp.bat 실행하여 AI 도구별 MCP 설정
echo 3. UE Editor에서 Python Remote Execution 활성화
echo    Edit -^> Project Settings -^> Plugins -^> Python -^> Enable Remote Execution
echo.
pause
