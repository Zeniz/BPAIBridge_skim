@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo [TEST] BPAIBridge MCP 서버 수동 테스트
echo ========================================
echo.
echo * 이 스크립트는 테스트 전용입니다.
echo   Claude Code는 자동으로 MCP 서버를 시작하므로
echo   일반 사용 시에는 실행할 필요가 없습니다.
echo.

echo ----------------------------------------
echo [필수 입력] UE 프로젝트 경로
echo ----------------------------------------
echo BPAIBridge가 설치된 프로젝트 경로를 입력하세요.
echo.
set /p PROJECT_PATH=프로젝트 경로:

REM 경로 끝의 백슬래시 제거
if "%PROJECT_PATH:~-1%"=="\" set PROJECT_PATH=%PROJECT_PATH:~0,-1%

set MCP_DIR=%PROJECT_PATH%\Plugins\BPAIBridge\mcp

REM 가상환경 체크
if not exist "%MCP_DIR%\venv\Scripts\python.exe" (
    echo.
    echo [실패] BPAIBridge가 설치되지 않았습니다.
    echo        먼저 02_install.bat을 실행하세요.
    echo        확인 경로: %MCP_DIR%
    pause
    exit /b 1
)

cd /d "%MCP_DIR%"
call venv\Scripts\activate.bat

echo.
echo ========================================
echo 환경 정보
echo ========================================

echo Python 경로:
where python

echo.
echo Python 버전:
python --version

echo.
echo 설치된 패키지:
pip list | findstr -i "mcp pydantic httpx"

echo.
echo ========================================
echo MCP 서버 시작
echo ========================================
echo.
echo 서버가 시작됩니다. Unreal Editor가 실행 중이어야 연결됩니다.
echo.
echo [대기] Unreal Engine Python Remote Execution 연결 대기 중...
echo        Edit -^> Project Settings -^> Plugins -^> Python -^> Enable Remote Execution
echo.
echo 서버를 종료하려면 Ctrl+C를 누르세요.
echo ----------------------------------------
echo.

python -m bpaibridge.server

echo.
echo ========================================
echo 서버 종료됨
echo ========================================
pause
