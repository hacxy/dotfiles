#!/bin/bash
# dfm - dotfiles manager
# 用法:
#   dfm install [tool...]    安装工具
#   dfm status [tool...]     检查状态
#   dfm list                 列出所有工具
#   dfm help                 显示帮助

set -e

DOTFILES_DIR="$HOME/dotfiles"
TOOLS_DIR="$DOTFILES_DIR/tools"
STATE_DIR="$HOME/.dfm"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 初始化状态目录
init_state_dir() {
  mkdir -p "$STATE_DIR"
}

# 获取所有可用工具
get_all_tools() {
  local tools=()
  for script in "$TOOLS_DIR"/*.sh; do
    if [ -f "$script" ]; then
      local tool_name=$(basename "$script" .sh)
      tools+=("$tool_name")
    fi
  done
  echo "${tools[@]}"
}

# 加载工具脚本
load_tool() {
  local tool=$1
  local script="$TOOLS_DIR/$tool.sh"
  
  if [ ! -f "$script" ]; then
    echo -e "${RED}✗ 未知工具: $tool${NC}"
    return 1
  fi
  
  source "$script"
}

# 检查工具是否已安装
is_tool_installed() {
  local tool=$1
  load_tool "$tool"
  check_installed
}

# 保存工具状态
save_tool_state() {
  local tool=$1
  local status=$2
  init_state_dir
  echo "$status" > "$STATE_DIR/$tool.state"
}

# 读取工具状态
read_tool_state() {
  local tool=$1
  local state_file="$STATE_DIR/$tool.state"
  
  if [ -f "$state_file" ]; then
    cat "$state_file"
  else
    echo "unknown"
  fi
}

# 安装单个工具
install_tool() {
  local tool=$1
  
  echo -e "\n${BLUE}=== 安装 $tool ===${NC}"
  
  # 加载工具脚本
  if ! load_tool "$tool"; then
    return 1
  fi
  
  # 获取工具信息
  local name=$(tool_name)
  local desc=$(tool_description)
  
  echo -e "${BLUE}$name: $desc${NC}"
  
  # 检查是否已安装
  if check_installed; then
    echo -e "${GREEN}✓ $name 已安装，跳过${NC}"
    save_tool_state "$tool" "installed"
    return 0
  fi
  
  # 安装依赖
  echo -e "${YELLOW}📦 安装 $name 依赖...${NC}"
  if ! install; then
    echo -e "${RED}✗ $name 依赖安装失败${NC}"
    save_tool_state "$tool" "failed"
    return 1
  fi
  
  # 配置
  echo -e "${YELLOW}⚙️  配置 $name...${NC}"
  if ! configure; then
    echo -e "${RED}✗ $name 配置失败${NC}"
    save_tool_state "$tool" "failed"
    return 1
  fi
  
  echo -e "${GREEN}✓ $name 安装完成${NC}"
  save_tool_state "$tool" "installed"
  return 0
}

# 显示工具状态
show_tool_status() {
  local tool=$1
  
  # 加载工具脚本
  if ! load_tool "$tool"; then
    return 1
  fi
  
  # 获取工具信息
  local name=$(tool_name)
  local desc=$(tool_description)
  
  # 获取状态
  local status_output=$(status)
  local status_type=$(echo "$status_output" | cut -d'|' -f1)
  local status_detail=$(echo "$status_output" | cut -d'|' -f2)
  
  # 显示状态
  case $status_type in
    installed)
      echo -e "${GREEN}✓${NC} $name - $status_detail"
      ;;
    not_installed|not_configured)
      echo -e "${RED}✗${NC} $name - 未安装"
      ;;
    *)
      echo -e "${YELLOW}?${NC} $name - 未知状态"
      ;;
  esac
}

# 交互式安装
interactive_install() {
  echo -e "${BLUE}=== dfm 交互式安装 ===${NC}"
  echo "请选择要安装的工具（用空格分隔多个工具，回车确认）："
  echo ""
  
  local tools=($(get_all_tools))
  local selected=()
  
  # 显示工具列表
  for i in "${!tools[@]}"; do
    local tool="${tools[$i]}"
    if ! load_tool "$tool"; then
      continue
    fi
    local name=$(tool_name)
    local desc=$(tool_description)
    
    # 检查是否已安装
    local status_mark=" "
    if check_installed; then
      status_mark="${GREEN}✓${NC}"
    fi
    
    echo -e "$((i+1)). $status_mark $name - $desc"
  done
  
  echo ""
  read -p "输入工具编号（例如: 1 3 5）: " -a selections
  
  # 处理选择
  for sel in "${selections[@]}"; do
    if [[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -ge 1 ] && [ "$sel" -le "${#tools[@]}" ]; then
      selected+=("${tools[$((sel-1))]}")
    fi
  done
  
  if [ ${#selected[@]} -eq 0 ]; then
    echo -e "${YELLOW}未选择任何工具${NC}"
    return 0
  fi
  
  echo -e "\n${BLUE}将安装以下工具:${NC}"
  for tool in "${selected[@]}"; do
    echo "  - $tool"
  done
  
  read -p "确认安装？[Y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}取消安装${NC}"
    return 0
  fi
  
  # 安装选中的工具
  local failed=0
  for tool in "${selected[@]}"; do
    if ! install_tool "$tool"; then
      failed=$((failed + 1))
    fi
  done
  
  if [ $failed -eq 0 ]; then
    echo -e "\n${GREEN}✅ 所有工具安装完成！${NC}"
  else
    echo -e "\n${YELLOW}⚠️  部分工具安装失败，请检查日志${NC}"
  fi
}

# 显示帮助
show_help() {
  echo "dfm - dotfiles manager"
  echo ""
  echo "用法:"
  echo "  dfm install [tool...]    安装工具"
  echo "  dfm status [tool...]     检查状态"
  echo "  dfm list                 列出所有工具"
  echo "  dfm help                 显示帮助"
  echo ""
  echo "示例:"
  echo "  dfm install              # 交互式安装"
  echo "  dfm install brew nvim    # 安装指定工具"
  echo "  dfm status               # 显示所有工具状态"
  echo "  dfm status nvim zsh      # 显示指定工具状态"
  echo "  dfm list                 # 列出所有可用工具"
  echo ""
  echo "工具列表:"
  local tools=($(get_all_tools))
  for tool in "${tools[@]}"; do
    load_tool "$tool"
    local name=$(tool_name)
    local desc=$(tool_description)
    echo "  $name - $desc"
  done
}

# 列出所有工具
list_tools() {
  echo -e "${BLUE}=== 可用工具 ===${NC}"
  echo ""
  
  local tools=($(get_all_tools))
  for tool in "${tools[@]}"; do
    load_tool "$tool"
    local name=$(tool_name)
    local desc=$(tool_description)
    echo "  $name - $desc"
  done
}

# 主函数
main() {
  # 初始化状态目录
  init_state_dir
  
  # 解析参数
  case "${1:-}" in
    install)
      shift
      if [ $# -eq 0 ]; then
        # 无参数，交互式安装
        interactive_install
      else
        # 有参数，安装指定工具
        local failed=0
        for tool in "$@"; do
          if ! install_tool "$tool"; then
            failed=$((failed + 1))
          fi
        done
        
        if [ $failed -eq 0 ]; then
          echo -e "\n${GREEN}✅ 所有工具安装完成！${NC}"
        else
          echo -e "\n${YELLOW}⚠️  部分工具安装失败，请检查日志${NC}"
        fi
      fi
      ;;
    status)
      shift
      if [ $# -eq 0 ]; then
        # 无参数，显示所有工具状态
        echo -e "${BLUE}=== 工具状态 ===${NC}"
        echo ""
        local tools=($(get_all_tools))
        for tool in "${tools[@]}"; do
          show_tool_status "$tool"
        done
      else
        # 有参数，显示指定工具状态
        for tool in "$@"; do
          show_tool_status "$tool"
        done
      fi
      ;;
    list)
      list_tools
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      echo -e "${RED}未知命令: ${1:-}${NC}"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

# 运行主函数
main "$@"