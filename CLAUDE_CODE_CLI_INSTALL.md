# Claude Code CLI 설치 가이드

Claude Code는 Anthropic이 제공하는 공식 CLI 도구로, 터미널에서 Claude AI와 대화하면서 코딩 작업을 수행할 수 있습니다.

## 사전 요구사항

- **Node.js 18 이상** 또는 **Bun 1.0 이상**
- **Windows 10/11** (이 가이드 기준)

---

## 설치 방법

### 방법 1: npm 사용 (권장)

```bash
npm install -g @anthropic-ai/claude-code
```

### 방법 2: Bun 사용

```bash
bun install -g @anthropic-ai/claude-code
```

### 방법 3: pnpm 사용

```bash
pnpm install -g @anthropic-ai/claude-code
```

### 방법 4: yarn 사용

```bash
yarn global add @anthropic-ai/claude-code
```

---

## Node.js가 설치되어 있지 않은 경우

### Node.js 설치

1. **Node.js 공식 사이트** 방문: https://nodejs.org/
2. **LTS (Long Term Support)** 버전 다운로드 (18.x 이상)
3. 설치 프로그램 실행
4. **"Add to PATH"** 옵션이 선택되어 있는지 확인
5. 설치 완료 후 새 터미널을 열어 확인:

```bash
node --version
npm --version
```

---

## 설치 확인

설치가 완료되면 다음 명령어로 확인합니다:

```bash
claude --version
```

버전 정보가 출력되면 설치 성공입니다.

---

## 첫 실행 및 인증

1. 터미널에서 `claude` 명령 실행:

```bash
claude
```

2. 브라우저가 열리며 Anthropic 계정 로그인 페이지가 표시됩니다.
3. 로그인 후 터미널로 돌아오면 Claude Code 사용 준비 완료입니다.

> **참고**: Claude Pro 또는 Claude Max 구독이 필요합니다.

---

## MCP 서버 설정

Claude Code가 설치되면, BPAIBridge MCP 서버를 설정할 수 있습니다.

### 프로젝트별 설정 (권장)

프로젝트 루트에 `.mcp.json` 파일 생성:

```json
{
  "mcpServers": {
    "bpaibridge": {
      "command": "D:/BPAIBridge/mcp_server/venv/Scripts/python.exe",
      "args": ["-m", "bpaibridge.server"],
      "cwd": "D:/BPAIBridge/mcp_server"
    }
  }
}
```

### 전역 설정

`~/.claude.json` 파일 수정 (Windows: `C:\Users\사용자이름\.claude.json`):

```json
{
  "mcpServers": {
    "bpaibridge": {
      "command": "D:/BPAIBridge/mcp_server/venv/Scripts/python.exe",
      "args": ["-m", "bpaibridge.server"],
      "cwd": "D:/BPAIBridge/mcp_server"
    }
  }
}
```

> **중요**: 경로는 실제 BPAIBridge 설치 위치에 맞게 수정하세요.

---

## 자주 사용하는 명령어

| 명령어 | 설명 |
|-------|------|
| `claude` | Claude Code 대화형 모드 시작 |
| `claude --version` | 버전 확인 |
| `claude --help` | 도움말 표시 |
| `claude "질문"` | 단일 질문 실행 |

---

## 문제 해결

### "claude 명령을 찾을 수 없습니다"

1. npm이 전역 패키지를 설치한 경로가 PATH에 포함되어 있는지 확인:
   ```bash
   npm config get prefix
   ```
2. 출력된 경로의 `bin` 폴더가 시스템 PATH에 있는지 확인
3. 터미널을 재시작

### "Node.js 버전이 낮습니다"

Node.js 18 이상이 필요합니다. 버전 확인:
```bash
node --version
```

낮은 경우 Node.js를 업그레이드하세요.

### "인증 실패"

1. Anthropic 계정에 로그인되어 있는지 확인
2. Claude Pro 또는 Claude Max 구독이 활성화되어 있는지 확인
3. `claude logout` 후 다시 `claude`로 재로그인

---

## 참고 문서

- **Claude Code 공식 문서**: https://docs.anthropic.com/en/docs/claude-code
- **MCP 설정 가이드**: https://docs.anthropic.com/en/docs/claude-code/tutorials/set-up-mcp
- **Node.js 다운로드**: https://nodejs.org/

---

## 다음 단계

Claude Code 설치가 완료되면:

1. `02_install.bat` 실행하여 BPAIBridge 설치
2. `03_setup_mcp.bat` 실행하여 MCP 설정
3. Unreal Editor에서 Python Remote Execution 활성화
4. 프로젝트 폴더에서 `claude` 명령 실행
