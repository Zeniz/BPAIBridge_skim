@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo BPAIBridge MCP 설정
echo ========================================
echo.

echo ----------------------------------------
echo [필수 입력] UE 프로젝트 경로
echo ----------------------------------------
echo BPAIBridge가 설치된 언리얼 프로젝트의 루트 폴더를 입력하세요.
echo.
echo 예시: D:\MyProject
echo.
set /p PROJECT_PATH=프로젝트 경로:

REM 경로 끝의 백슬래시 제거
if "%PROJECT_PATH:~-1%"=="\" set PROJECT_PATH=%PROJECT_PATH:~0,-1%

REM 설치 확인 (플러그인 내 mcp 폴더)
set MCP_DIR=%PROJECT_PATH%\Plugins\BPAIBridge\mcp
if not exist "%MCP_DIR%\venv\Scripts\python.exe" (
    echo.
    echo [오류] BPAIBridge가 설치되지 않았습니다.
    echo        먼저 02_install.bat을 실행하세요.
    echo        확인 경로: %MCP_DIR%
    pause
    exit /b 1
)

set PYTHON_PATH=%MCP_DIR%\venv\Scripts\python.exe

REM 경로를 슬래시로 변환 (JSON용)
set PYTHON_PATH_JSON=%PYTHON_PATH:\=/%
set MCP_DIR_JSON=%MCP_DIR:\=/%

echo.
echo 설치 확인됨: %MCP_DIR%
echo.

echo ----------------------------------------
echo [AI 도구 선택]
echo ----------------------------------------
echo 1. Claude Code
echo 2. Cursor
echo 3. Gemini CLI
echo 4. 수동 설치 가이드 (직접 설정)
echo.
set /p AI_TOOL=선택 (1/2/3/4):

if "%AI_TOOL%"=="1" goto CLAUDE_CODE
if "%AI_TOOL%"=="2" goto CURSOR
if "%AI_TOOL%"=="3" goto GEMINI
if "%AI_TOOL%"=="4" goto MANUAL_GUIDE
goto INVALID_CHOICE

:CLAUDE_CODE
echo.
echo ----------------------------------------
echo [Claude Code 설정 방식]
echo ----------------------------------------
echo 1. 프로젝트별 설정 (.mcp.json) - 권장
echo 2. 전역 설정 (~/.claude.json)
echo.
set /p CLAUDE_CHOICE=선택 (1/2):

if "%CLAUDE_CHOICE%"=="1" (
    set MCP_FILE=%PROJECT_PATH%\.mcp.json
    call :WRITE_MCP_CONFIG "!MCP_FILE!"
    echo.
    echo [성공] !MCP_FILE! 파일이 생성되었습니다.
    echo.
    echo 참고 문서: https://docs.anthropic.com/en/docs/claude-code/mcp
) else if "%CLAUDE_CHOICE%"=="2" (
    set MCP_FILE=%USERPROFILE%\.claude.json
    call :WRITE_MCP_CONFIG "!MCP_FILE!"
    echo.
    echo [성공] !MCP_FILE! 파일이 생성되었습니다.
    echo.
    echo 참고 문서: https://docs.anthropic.com/en/docs/claude-code/mcp
)
goto END

:CURSOR
echo.
set CURSOR_DIR=%USERPROFILE%\.cursor
if not exist "!CURSOR_DIR!" mkdir "!CURSOR_DIR!"
set MCP_FILE=!CURSOR_DIR!\mcp.json
call :WRITE_MCP_CONFIG "!MCP_FILE!"
echo.
echo [성공] !MCP_FILE! 파일이 생성되었습니다.
echo.
echo 참고 문서: https://docs.cursor.com/
goto END

:GEMINI
echo.
set GEMINI_DIR=%USERPROFILE%\.gemini
if not exist "!GEMINI_DIR!" mkdir "!GEMINI_DIR!"
set MCP_FILE=!GEMINI_DIR!\settings.json
call :WRITE_MCP_CONFIG "!MCP_FILE!"
echo.
echo [성공] !MCP_FILE! 파일이 생성되었습니다.
echo.
echo 참고 문서: https://github.com/anthropics/anthropic-cookbook
goto END

:MANUAL_GUIDE
echo.
echo ========================================
echo 수동 설치 가이드
echo ========================================
echo.
echo MCP 설정 JSON 내용 (아래 내용을 복사하세요):
echo.
echo {
echo   "mcpServers": {
echo     "bpaibridge": {
echo       "command": "%PYTHON_PATH_JSON%",
echo       "args": ["-m", "bpaibridge.server"],
echo       "cwd": "%MCP_DIR_JSON%"
echo     }
echo   }
echo }
echo.
echo ----------------------------------------
echo AI 도구별 설정 파일 위치:
echo ----------------------------------------
echo.
echo [Claude Code]
echo   - 프로젝트별: %PROJECT_PATH%\.mcp.json
echo   - 전역: %%USERPROFILE%%\.claude.json
echo   - 문서: https://docs.anthropic.com/en/docs/claude-code/mcp
echo.
echo [Cursor]
echo   - 설정 파일: %%USERPROFILE%%\.cursor\mcp.json
echo   - 문서: https://docs.cursor.com/
echo.
echo [Gemini CLI]
echo   - 설정 파일: %%USERPROFILE%%\.gemini\settings.json
echo   - 문서: https://github.com/anthropics/anthropic-cookbook
echo.
goto END

:INVALID_CHOICE
echo [오류] 잘못된 선택입니다.
goto END

:WRITE_MCP_CONFIG
(
echo {
echo   "mcpServers": {
echo     "bpaibridge": {
echo       "command": "%PYTHON_PATH_JSON%",
echo       "args": ["-m", "bpaibridge.server"],
echo       "cwd": "%MCP_DIR_JSON%"
echo     }
echo   }
echo }
) > %~1
exit /b

:END
echo.
echo ========================================
echo 설정 완료!
echo ========================================
echo.
echo 이제 선택한 AI 도구에서 BPAIBridge MCP를 사용할 수 있습니다.
echo.
echo 사용 전 확인사항:
echo 1. Unreal Editor가 실행 중이어야 합니다.
echo 2. Python Remote Execution이 활성화되어 있어야 합니다.
echo    Edit -^> Project Settings -^> Plugins -^> Python -^> Enable Remote Execution
echo.
pause
