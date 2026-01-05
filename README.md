# BPAIBridge_skim
BPAIBridge plugin with installer skim version for sample.

AI 도구(Claude Code, Cursor, Gemini CLI 등)에서 Unreal Engine Blueprint를 분석하고 읽을 수 있게 해주는 MCP(Model Context Protocol) 서버입니다.

## 주요 기능

### Blueprint 분석
- Blueprint 그래프 구조를 텍스트/JSON으로 읽기
- Blueprint 변수, 함수, 이벤트, 매크로, 인터페이스 목록 조회
- 컴포넌트 분석 및 비교
- Blueprint → C++ 변환 분석

### AnimBlueprint 분석
- AnimBlueprint State Machine 구조 분석
- Transition Rule 읽기
- Anim Layer 정보 조회
- 함수 및 변수 분석

### 유틸리티
- 함수/클래스 검색 및 유효성 검사
- 에셋 의존성 분석
- Material 그래프 읽기

## 사전 요구사항

- **Python 3.10 이상**
- **Unreal Engine 5.x** (Python Remote Execution 지원)
- **MCP 지원 AI 도구** (Claude Code, Cursor, Gemini CLI 등)

## 설치 방법

### 1단계: 환경 체크

```batch
01_check_environment.bat
```

Python, pip 설치 여부와 네트워크 연결 상태를 확인합니다.

### 2단계: 설치

```batch
02_install.bat
```

- UE 프로젝트 경로 입력
- BPAIBridge 플러그인 복사 (C++ 플러그인 + MCP 서버)
- Python 가상환경(venv) 생성
- 의존성 패키지 설치

**설치 후 프로젝트 구조:**
```
YourProject/
├── Plugins/
│   └── BPAIBridge/
│       ├── Source/BPAIBridge/   (C++ 플러그인)
│       ├── mcp/                  (MCP 서버 + venv)
│       │   ├── src/bpaibridge/
│       │   ├── venv/
│       │   └── ...
│       └── BPAIBridge.uplugin
└── .mcp.json                     (MCP 설정)
```

### 3단계: UE 프로젝트 빌드 (필수)

C++ 플러그인이 추가되었으므로 프로젝트를 다시 빌드해야 합니다.

**방법 1: Visual Studio 사용**
1. `프로젝트폴더\프로젝트이름.sln` 파일 열기
2. 빌드 > 솔루션 빌드 (Ctrl+Shift+B)

**방법 2: GenerateProjectFiles 사용**
1. `프로젝트폴더\GenerateProjectFiles.bat` 실행
2. Visual Studio에서 빌드

**방법 3: Editor에서 직접 빌드**
1. Unreal Editor 실행
2. 플러그인 빌드 프롬프트가 나타나면 Yes 클릭

### 4단계: AI 도구별 MCP 설정

```batch
03_setup_mcp.bat
```

사용하는 AI 도구를 선택하면 자동으로 MCP 설정 파일을 생성합니다.

| 선택 | AI 도구 | 설정 파일 위치 |
|-----|---------|--------------|
| 1 | Claude Code (프로젝트별) | `프로젝트폴더\.mcp.json` |
| 1 | Claude Code (전역) | `~\.claude.json` |
| 2 | Cursor | `~\.cursor\mcp.json` |
| 3 | Gemini CLI | `~\.gemini\settings.json` |
| 4 | 수동 설치 | JSON 내용 출력 |

### 5단계: Unreal Engine 설정

1. Unreal Editor를 실행합니다.
2. **Edit → Project Settings → Plugins → Python** 으로 이동합니다.
3. **Enable Remote Execution**을 체크합니다.
4. Multicast Group Endpoint: `239.0.0.1:6766` (기본값)

## MCP 설정 예시

```json
{
  "mcpServers": {
    "bpaibridge": {
      "command": "D:/YourProject/Plugins/BPAIBridge/mcp/venv/Scripts/python.exe",
      "args": ["-m", "bpaibridge.server"],
      "cwd": "D:/YourProject/Plugins/BPAIBridge/mcp"
    }
  }
}
```

> **주의**: 경로는 실제 프로젝트 위치에 맞게 자동 생성됩니다.

## 사용 가능한 MCP 도구

### 연결 및 기본
- `connect_unreal` - Unreal Editor 연결
- `list_blueprints` - 프로젝트 내 모든 Blueprint 목록
- `list_materials` - 프로젝트 내 모든 Material 목록

### Blueprint 읽기
- `read_blueprint_nodes` - Blueprint 노드를 텍스트로 읽기
- `read_blueprint_nodes_json` - Blueprint 노드를 JSON으로 읽기
- `read_blueprint_graph` - Blueprint 그래프 구조 읽기
- `get_blueprint_overview` - Blueprint 개요 (클래스 계층, 컴포넌트 등)

### Blueprint 분석
- `list_blueprint_functions` - 함수/이벤트/매크로 목록
- `list_blueprint_variables` - 변수 목록
- `get_blueprint_function_info` - 특정 함수 상세 정보
- `get_blueprint_event_info` - 특정 이벤트 상세 정보
- `list_blueprint_interfaces` - 구현된 인터페이스 목록
- `list_blueprint_components` - 컴포넌트 목록
- `compare_blueprint_components` - 두 Blueprint 컴포넌트 비교

### Blueprint → C++ 변환
- `bp_cpp_convert` - Blueprint를 C++ 코드로 변환 분석
- `bp_execute_batch` - 여러 Blueprint 일괄 분석

### AnimBlueprint 분석
- `animbp_read` - AnimBlueprint 전체 구조 읽기
- `animbp_state_get_properties` - State 속성 조회
- `animbp_transition_read_rule` - Transition Rule 읽기
- `animbp_list_variables` - AnimBlueprint 변수 목록
- `animbp_list_functions` - AnimBlueprint 함수 목록
- `animbp_execute_batch` - 여러 AnimBlueprint 일괄 분석

### Material 읽기
- `read_material_graph` - Material 그래프 구조 읽기

### 유효성 검사
- `validate_function` - 함수 존재 여부 확인
- `search_functions` - 함수 검색
- `get_class_functions` - 클래스의 모든 함수 조회

### 에셋 유틸리티
- `list_assets_in_folder` - 폴더 내 에셋 목록
- `get_asset_dependencies` - 에셋 의존성 분석
- `get_asset_referencers` - 에셋을 참조하는 다른 에셋 조회

## 테스트

MCP 서버가 제대로 동작하는지 확인하려면:

```batch
[TEST]_manual_server_start.bat
```

> **참고**: 일반 사용 시에는 실행할 필요 없습니다. Claude Code 등 AI 도구가 자동으로 MCP 서버를 시작합니다.

## 문제 해결

### "Unreal Engine에 연결할 수 없습니다"

1. Unreal Editor가 실행 중인지 확인
2. Python Remote Execution이 활성화되어 있는지 확인
3. 방화벽에서 UDP 6766 포트가 열려있는지 확인

### "플러그인을 찾을 수 없습니다"

1. BPAIBridge 플러그인이 `프로젝트/Plugins/BPAIBridge/` 폴더에 있는지 확인
2. Unreal 프로젝트를 다시 빌드
3. Editor에서 플러그인이 활성화되어 있는지 확인 (Edit → Plugins)

### "MCP 서버 시작 실패"

1. Python 가상환경이 올바르게 생성되었는지 확인
2. `Plugins\BPAIBridge\mcp\venv\Scripts\python.exe` 파일이 존재하는지 확인
3. 의존성 패키지가 설치되었는지 확인

### "함수/클래스를 찾을 수 없습니다"

1. Unreal Editor에서 해당 클래스가 로드되어 있는지 확인
2. 클래스명에 접두사(A, U, F)를 생략하고 시도
3. `search_functions` 도구로 유사한 함수명 검색

## 폴더 구조

**배포 패키지:**
```
BPAIBridge/
├── README.md                          # 이 파일
├── 01_check_environment.bat           # 환경 체크
├── 02_install.bat                     # 설치 스크립트
├── 03_setup_mcp.bat                   # MCP 설정
├── [TEST]_manual_server_start.bat     # 테스트용 서버 시작
│
└── ue_plugin/                         # 설치될 플러그인
    └── BPAIBridge/
        ├── BPAIBridge.uplugin
        ├── Config/
        ├── mcp/                       # MCP 서버 (Python)
        │   ├── src/bpaibridge/
        │   ├── pyproject.toml
        │   └── requirements.txt
        └── Source/BPAIBridge/         # C++ 플러그인
            ├── BPAIBridge.Build.cs
            ├── Public/
            └── Private/
```

**설치 후 프로젝트:**
```
YourProject/
├── Plugins/
│   └── BPAIBridge/
│       ├── mcp/
│       │   └── venv/                  # 설치 시 생성
│       └── ...
└── .mcp.json                          # MCP 설정
```

## 라이선스

이 프로젝트는 자유롭게 사용, 수정, 배포할 수 있습니다.
