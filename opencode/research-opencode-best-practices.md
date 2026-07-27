# OpenCode 最佳实践调研

> 本调研基于 [opencode.ai/docs](https://opencode.ai/docs/) 官方文档和 [GitHub 仓库](https://github.com/anomalyco/opencode) 整理。最后更新：2026 年 7 月。

---

## 1. 什么是 OpenCode？

OpenCode 是一个开源的 AI 编程助手，提供终端 TUI、桌面应用和 IDE 插件三种形态。GitHub 超过 190K+ Stars，每月有 750 万+ 开发者使用。

**核心功能：**
- **多模型支持** — 通过 [models.dev](https://models.dev) 支持 75+ 个 LLM 提供商，包括 Anthropic、OpenAI、Gemini 及本地模型
- **内置 Agent** — `build`（完全访问）和 `plan`（只读）两个主 Agent，按 `Tab` 切换
- **子 Agent** — `general`、`explore`、`scout` 用于专项任务，可通过 `@提及` 调用
- **LSP 集成** — 自动加载对应语言的 LSP 服务器，提供代码智能提示
- **多会话** — 同一项目可并行运行多个 Agent
- **会话分享** — 通过 `/share` 命令分享对话
- **撤销/重做** — `/undo` 和 `/redo` 命令回退 Agent 的修改
- **快照系统** — 使用内部 git 仓库跟踪文件变更，支持回滚
- **隐私优先** — 不存储代码或上下文数据

**来源：**
- [opencode.ai](https://opencode.ai)
- [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)
- [opencode.ai/docs/](https://opencode.ai/docs/)

---

## 2. 配置模式

### 2.1 配置文件格式

OpenCode 支持 `opencode.json` 和 `opencode.jsonc`（支持注释的 JSON）。`$schema` 字段可启用编辑器自动补全：

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5",
  "autoupdate": true
}
```

**来源：** [opencode.ai/docs/config/](https://opencode.ai/docs/config/)

### 2.2 配置文件位置（优先级顺序）

配置文件会**合并**，而非替换。冲突时，后出现的源覆盖先出现的：

1. **远程配置**（`.well-known/opencode`）— 组织级默认值
2. **全局配置**（`~/.config/opencode/opencode.json`）— 用户偏好
3. **自定义配置**（`OPENCODE_CONFIG` 环境变量）— 自定义覆盖
4. **项目配置**（项目根目录的 `opencode.json`）— 项目特定配置
5. **`.opencode` 目录** — agents、commands、plugins、skills
6. **内联配置**（`OPENCODE_CONFIG_CONTENT` 环境变量）— 运行时覆盖
7. **托管配置**（macOS 上 `/Library/Application Support/opencode/`）— 管理员控制
8. **macOS 托管偏好**（通过 MDM 下发的 `.mobileconfig`）— 最高优先级

**最佳实践：** 项目特定配置放在项目根目录的 `opencode.json`（可安全提交到 Git）。个人偏好（提供商、API Key）放在 `~/.config/opencode/opencode.json`。

**来源：** [opencode.ai/docs/config/#precedence-order](https://opencode.ai/docs/config/#precedence-order)

### 2.3 推荐配置模板

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5",
  "formatter": true,
  "lsp": true,
  "permission": {
    "bash": {
      "*": "ask",
      "git status *": "allow",
      "git diff *": "allow",
      "git log *": "allow",
      "npm *": "allow",
      "grep *": "allow"
    },
    "edit": "allow"
  },
  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md"]
}
```

**来源：** [opencode.ai/docs/config/](https://opencode.ai/docs/config/)、[opencode.ai/docs/permissions/](https://opencode.ai/docs/permissions/)

### 2.4 TUI 配置

TUI 相关设置使用单独的 `tui.json` 文件：

```json
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "tokyonight",
  "scroll_speed": 3,
  "mouse": true,
  "attention": {
    "enabled": true,
    "notifications": true,
    "sound": true
  }
}
```

**来源：** [opencode.ai/docs/config/#tui](https://opencode.ai/docs/config/#tui)

### 2.5 变量替换

配置文件支持环境变量和文件内容替换：

```jsonc
{
  "model": "{env:OPENCODE_MODEL}",
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "{env:ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

文件引用：`{file:path/to/file}` — 路径相对于配置文件或使用绝对路径。

**来源：** [opencode.ai/docs/config/#variables](https://opencode.ai/docs/config/#variables)

---

## 3. AGENTS.md 模式

### 3.1 什么是 AGENTS.md？

`AGENTS.md` 是规则文件（类似 Cursor 的 rules），为 LLM 提供自定义指令。它会被加载到上下文中，用于自定义项目行为。

**来源：** [opencode.ai/docs/rules/](https://opencode.ai/docs/rules/)

### 3.2 初始化

在 OpenCode 中运行 `/init` 可自动生成 `AGENTS.md`。它会扫描你的仓库并创建以下指导：
- 构建、lint 和测试命令
- 架构和仓库结构
- 项目特定约定
- 对现有指令源的引用

**最佳实践：** 将 `AGENTS.md` 提交到 Git。

**来源：** [opencode.ai/docs/rules/#initialize](https://opencode.ai/docs/rules/#initialize)

### 3.3 AGENTS.md 位置

| 位置 | 作用域 | 团队共享？ |
|---|---|---|
| `./AGENTS.md`（项目根目录） | 项目特定 | 是（通过 Git） |
| `~/.config/opencode/AGENTS.md` | 全局（所有会话） | 否 |
| `CLAUDE.md`（项目根目录） | Claude Code 兼容回退 | 是 |
| `~/.claude/CLAUDE.md` | Claude Code 兼容回退 | 否 |

**优先级：** 项目 `AGENTS.md` > 项目 `CLAUDE.md` > 全局 `AGENTS.md` > 全局 `CLAUDE.md`

**来源：** [opencode.ai/docs/rules/#types](https://opencode.ai/docs/rules/#types)

### 3.4 有效的 AGENTS.md 结构

```markdown
# 项目名称

## 项目结构
- `packages/` — 工作区包
- `infra/` — 基础设施定义
- `src/` — 源代码

## 代码规范
- 使用 TypeScript 严格模式
- 共享代码放在 `packages/core/`
- 函数放在 `packages/functions/`

## 构建和测试命令
- `bun run build` — 构建所有包
- `bun test` — 运行测试
- `bun typecheck` — 类型检查

## Monorepo 约定
- 使用工作区名称导入共享模块：`@my-app/core/example`
- 使用 Effect schema helpers 进行 JSON 解析
- 优先使用函数式数组方法而非 for 循环
```

**来源：** [opencode.ai/docs/rules/#example](https://opencode.ai/docs/rules/#example)

### 3.5 引用外部文件

在 AGENTS.md 中使用 `@` 引用并配合延迟加载指令：

```markdown
## 外部文件加载
重要：当你遇到文件引用（如 @rules/general.md）时，
使用 Read 工具按需加载。

## 开发指南
TypeScript 代码风格：@docs/typescript-guidelines.md
React 模式：@docs/react-patterns.md
```

或在 `opencode.json` 中使用 `instructions` 字段（推荐用于 monorepo）：

```jsonc
{
  "instructions": [
    "CONTRIBUTING.md",
    "docs/guidelines.md",
    ".cursor/rules/*.md",
    "packages/*/AGENTS.md"
  ]
}
```

**来源：** [opencode.ai/docs/rules/#referencing-external-files](https://opencode.ai/docs/rules/#referencing-external-files)

---

## 4. Agent 配置

### 4.1 内置 Agent

| Agent | 模式 | 用途 |
|---|---|---|
| `build` | 主 Agent | 完全访问，用于开发工作 |
| `plan` | 主 Agent | 只读，用于分析（编辑需审批） |
| `general` | 子 Agent | 复杂搜索和多步骤任务 |
| `explore` | 子 Agent | 快速只读代码库探索 |
| `scout` | 子 Agent | 外部文档和依赖研究 |
| `compaction` | 系统 | 自动压缩过长上下文 |
| `title` | 系统 | 生成会话标题 |
| `summary` | 系统 | 创建会话摘要 |

**来源：** [opencode.ai/docs/agents/#built-in](https://opencode.ai/docs/agents/#built-in)

### 4.2 自定义 Agent 模式

**JSON 配置：**
```jsonc
{
  "agent": {
    "code-reviewer": {
      "description": "代码审查，检查最佳实践",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-5",
      "prompt": "你是代码审查员。关注安全性、性能和可维护性。",
      "permission": {
        "edit": "deny",
        "bash": "ask"
      }
    }
  }
}
```

**Markdown 文件**（`.opencode/agents/review.md`）：
```markdown
---
description: 代码质量与最佳实践审查
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---
你处于代码审查模式。重点关注：
- 代码质量和最佳实践
- 潜在 bug 和边界情况
- 性能影响
- 安全考量
```

**来源：** [opencode.ai/docs/agents/#configure](https://opencode.ai/docs/agents/#configure)

### 4.3 Agent 权限粒度

权限支持 glob 模式，可细粒度控制：

```jsonc
{
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "*": "ask",
          "git status *": "allow",
          "git diff *": "allow",
          "grep *": "allow",
          "rm *": "deny"
        },
        "edit": {
          "*": "allow",
          "*.env*": "deny"
        }
      }
    }
  }
}
```

**来源：** [opencode.ai/docs/agents/#permissions](https://opencode.ai/docs/agents/#permissions)

### 4.4 交互式创建 Agent

```bash
opencode agent create
```

会生成带有正确 frontmatter 的 markdown agent 文件。

**来源：** [opencode.ai/docs/agents/#create-agents](https://opencode.ai/docs/agents/#create-agents)

---

## 5. 技能与插件

### 5.1 Agent 技能（Skills）

技能是可复用的指令集，通过 `skill` 工具按需加载。创建 `SKILL.md` 文件即可：

**位置：** `.opencode/skills/<name>/SKILL.md` 或 `~/.config/opencode/skills/<name>/SKILL.md`

**示例**（`.opencode/skills/git-release/SKILL.md`）：
```markdown
---
name: git-release
description: 创建一致的版本发布和变更日志
license: MIT
metadata:
  audience: maintainers
## 功能
- 从已合并 PR 草拟发布说明
- 建议版本号变更
- 提供可复制粘贴的 `gh release create` 命令
```

**命名规则：**
- 1–64 个字符，小写字母数字，单个连字符分隔
- 必须与目录名匹配
- 正则：`^[a-z0-9]+(-[a-z0-9]+)*$`

**来源：** [opencode.ai/docs/skills/](https://opencode.ai/docs/skills/)

### 5.2 技能权限

```jsonc
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

**来源：** [opencode.ai/docs/skills/#configure-permissions](https://opencode.ai/docs/skills/#configure-permissions)

### 5.3 插件（Plugins）

插件通过自定义工具、钩子和集成扩展 OpenCode。两种加载方式：

**本地文件：** 放在 `.opencode/plugins/` 或 `~/.config/opencode/plugins/`

**npm 包：**
```jsonc
{
  "plugin": ["opencode-helicone-session", "opencode-wakatime"]
}
```

**插件结构：**
```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async ({ project, client, $, directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      // 钩入工具执行流程
    },
  }
}
```

**可用事件：** `tool.execute.before`、`tool.execute.after`、`session.idle`、`session.created`、`file.edited`、`permission.asked`、`shell.env` 等。

**来源：** [opencode.ai/docs/plugins/](https://opencode.ai/docs/plugins/)

### 5.4 知名社区插件

| 插件 | 描述 |
|---|---|
| `opencode-helicone-session` | 使用 Helicone 进行会话追踪 |
| `opencode-wakatime` | 使用 WakaTime 进行使用量追踪 |
| `opencode-vibeguard` | 在 LLM 调用前脱敏 secrets/PII |
| `opencode-type-inject` | 自动将 TypeScript 类型注入文件读取 |
| `opencode-morph-fast-apply` | 10 倍速代码编辑 |
| `oh-my-opencode` | 后台 Agent、预构建工具、精选 Agent |
| `opencode-notificator` | 桌面通知和声音提醒 |
| `opencode-supermemory` | 跨会话持久记忆 |

**来源：** [opencode.ai/docs/ecosystem/#plugins](https://opencode.ai/docs/ecosystem/#plugins)

---

## 6. MCP 服务器集成

### 6.1 配置

MCP 服务器通过 Model Context Protocol 添加外部工具：

```jsonc
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp"
    },
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.dev/mcp",
      "oauth": {}
    },
    "my-local-server": {
      "type": "local",
      "command": ["npx", "-y", "my-mcp-command"],
      "enabled": true,
      "environment": {
        "MY_API_KEY": "value"
      }
    }
  }
}
```

**来源：** [opencode.ai/docs/mcp-servers/](https://opencode.ai/docs/mcp-servers/)

### 6.2 常用 MCP 服务器

| 服务器 | 类型 | 用途 |
|---|---|---|
| **Context7** | 远程 | 文档搜索 |
| **Sentry** | 远程（OAuth） | Issue 追踪和错误监控 |
| **Grep by Vercel** | 远程 | GitHub 代码搜索 |

### 6.3 MCP 最佳实践

- **精选使用** — MCP 服务器会增加上下文中的 token 数量。过多可能导致超出上下文限制。
- **按 Agent 配置工具** — 全局禁用 MCP 工具，仅对特定 Agent 启用：

```jsonc
{
  "tools": {
    "my-mcp*": false
  },
  "agent": {
    "my-agent": {
      "tools": {
        "my-mcp*": true
      }
    }
  }
}
```

- **在 AGENTS.md 中引用** — 告诉 Agent 何时使用 MCP 工具：

```markdown
需要搜索文档时，使用 `context7` 工具。
不确定怎么做时，使用 `gh_grep` 搜索代码示例。
```

**来源：** [opencode.ai/docs/mcp-servers/#manage](https://opencode.ai/docs/mcp-servers/#manage)

### 6.4 远程 MCP 服务器的 OAuth

OpenCode 会自动处理远程服务器的 OAuth。手动认证方式：

```bash
opencode mcp auth <server-name>
opencode mcp list        # 列出服务器和认证状态
opencode mcp logout <server-name>  # 移除凭证
```

**来源：** [opencode.ai/docs/mcp-servers/#oauth](https://opencode.ai/docs/mcp-servers/#oauth)

---

## 7. 工作流技巧

### 7.1 Plan → Build 工作流

1. 按 `Tab` 切换到 **Plan 模式**
2. 详细描述你的需求（就像和初级开发者沟通一样）
3. 迭代方案，可拖拽图片作为参考
4. 按 `Tab` 切换回 **Build 模式**
5. 让它实现

**来源：** [opencode.ai/docs/#add-features](https://opencode.ai/docs/#add-features)

### 7.2 使用 `@` 引用文件

使用 `@` 模糊搜索项目中的文件：
```
@packages/functions/src/api/index.ts 中的认证是怎么处理的？
```

**来源：** [opencode.ai/docs/#ask-questions](https://opencode.ai/docs/#ask-questions)

### 7.3 自定义命令

为重复性任务创建可复用命令：

`.opencode/commands/test.md`：
```markdown
---
description: 运行测试并生成覆盖率报告
agent: build
---
运行完整测试套件并生成覆盖率报告，展示失败项。
重点分析失败的测试并给出修复建议。
```

命令支持 `$ARGUMENTS`、`$1`、`$2`、shell 输出（`` !`command` ``）和文件引用（`@file`）。

**来源：** [opencode.ai/docs/commands/](https://opencode.ai/docs/commands/)

### 7.4 Auto 模式

使用 `--auto` 启动，自动批准未被拒绝的权限：

```bash
opencode --auto
opencode run --auto "重构这个模块"
```

**来源：** [opencode.ai/docs/permissions/#auto-mode](https://opencode.ai/docs/permissions/#auto-mode)

### 7.5 撤销/重做

- `/undo` — 回退上一次 Agent 修改并重新显示原始提示
- `/redo` — 重新应用已撤销的修改
- 可多次执行

**来源：** [opencode.ai/docs/#undo-changes](https://opencode.ai/docs/#undo-changes)

### 7.6 分享会话

```bash
/share  # 创建当前对话的可分享链接
```

配置分享行为：
```jsonc
{
  "share": "manual"  // "manual"（手动）、"auto"（自动）或 "disabled"（禁用）
}
```

**来源：** [opencode.ai/docs/share/](https://opencode.ai/docs/share/)

---

## 8. 常见陷阱

### 8.1 MCP 服务器过多

MCP 服务器的工具会增加上下文中的 token 数。例如 GitHub MCP 服务器很容易超出上下文限制。应精选启用哪些服务器。

**解决：** 全局禁用 MCP 工具，仅在需要时按 Agent 启用。

**来源：** [opencode.ai/docs/mcp-servers/#caveats](https://opencode.ai/docs/mcp-servers/#caveats)

### 8.2 未提交 AGENTS.md

`AGENTS.md` 应提交到 Git，让整个团队共享项目上下文。

**来源：** [opencode.ai/docs/rules/#initialize](https://opencode.ai/docs/rules/#initialize)

### 8.3 使用已废弃的 `tools` 配置

`tools` 布尔配置已废弃。应使用 `permission` 字段进行细粒度控制。

**来源：** [opencode.ai/docs/permissions/](https://opencode.ai/docs/permissions/)

### 8.4 大型仓库的快照开销

对于大型仓库，快照系统可能导致索引缓慢和大量磁盘占用。可按需禁用：

```jsonc
{
  "snapshot": false
}
```

注意：禁用快照意味着无法通过 UI 回滚修改。

**来源：** [opencode.ai/docs/config/#snapshot](https://opencode.ai/docs/config/#snapshot)

### 8.5 未使用 `small_model`

配置 `small_model` 用于轻量任务（标题生成等）以节省成本：

```jsonc
{
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5"
}
```

**来源：** [opencode.ai/docs/config/#models](https://opencode.ai/docs/config/#models)

### 8.6 忽略破坏性操作的权限

默认情况下，OpenCode **允许所有操作**无需审批。为安全起见，应为破坏性工具配置权限：

```jsonc
{
  "permission": {
    "bash": {
      "rm *": "deny",
      "git push *": "ask",
      "git commit *": "ask"
    },
    "edit": {
      "*.env*": "deny"
    }
  }
}
```

**来源：** [opencode.ai/docs/permissions/#defaults](https://opencode.ai/docs/permissions/#defaults)

### 8.7 `.env` 文件默认被拒绝读取

OpenCode 默认拒绝读取 `.env` 文件。如需读取：
```jsonc
{
  "permission": {
    "read": {
      "*.env": "allow"
    }
  }
}
```

**来源：** [opencode.ai/docs/permissions/#defaults](https://opencode.ai/docs/permissions/#defaults)

### 8.8 缺少 `external_directory` 权限

访问工作目录之外路径的工具需要 `external_directory` 权限：

```jsonc
{
  "permission": {
    "external_directory": {
      "~/projects/personal/**": "allow"
    }
  }
}
```

**来源：** [opencode.ai/docs/permissions/#external-directories](https://opencode.ai/docs/permissions/#external-directories)

---

## 9. 生态与社区资源

- **awesome-opencode** — [github.com/awesome-opencode/awesome-opencode](https://github.com/awesome-opencode/awesome-opencode)
- **opencode.cafe** — 生态项目社区聚合页
- **Discord** — [opencode.ai/discord](https://opencode.ai/discord)
- **生态页面** — [opencode.ai/docs/ecosystem/](https://opencode.ai/docs/ecosystem/)

---

## 参考资料

| 来源 | URL |
|---|---|
| OpenCode 官网 | https://opencode.ai |
| GitHub 仓库 | https://github.com/anomalyco/opencode |
| 文档首页 | https://opencode.ai/docs/ |
| 配置文档 | https://opencode.ai/docs/config/ |
| Agent 文档 | https://opencode.ai/docs/agents/ |
| 规则文档 | https://opencode.ai/docs/rules/ |
| 技能文档 | https://opencode.ai/docs/skills/ |
| MCP 服务器文档 | https://opencode.ai/docs/mcp-servers/ |
| 插件文档 | https://opencode.ai/docs/plugins/ |
| 工具文档 | https://opencode.ai/docs/tools/ |
| 权限文档 | https://opencode.ai/docs/permissions/ |
| 命令文档 | https://opencode.ai/docs/commands/ |
| 生态文档 | https://opencode.ai/docs/ecosystem/ |
| OpenCode AGENTS.md（仓库） | https://raw.githubusercontent.com/anomalyco/opencode/dev/AGENTS.md |
