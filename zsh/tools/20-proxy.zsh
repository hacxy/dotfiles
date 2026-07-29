# ============================================================
# 代理配置
# 用法: proxy on / proxy off / proxy status
# shellcheck disable=SC2120,SC2119
# ============================================================

# 可通过环境变量覆盖代理地址
__proxy_host="${PROXY_HOST:-127.0.0.1}"
__proxy_port="${PROXY_PORT:-7890}"
__proxy_url="http://${__proxy_host}:${__proxy_port}"
__proxy_no_proxy="localhost,127.0.0.1,token-plan-cn.xiaomimimo.com"

proxy() {
  case "$1" in
    off)
      unset http_proxy https_proxy all_proxy no_proxy NO_PROXY
      unset HOMEBREW_HTTP_PROXY HOMEBREW_HTTPS_PROXY HOMEBREW_ALL_PROXY HOMEBREW_NO_PROXY
      echo "✗ Proxy disabled"
      ;;
    status)
      if [[ -n "$http_proxy" ]]; then
        echo "✓ Proxy enabled ($http_proxy)"
      else
        echo "✗ Proxy disabled"
      fi
      ;;
    *)
      export http_proxy="$__proxy_url"
      export https_proxy="$__proxy_url"
      export all_proxy="$__proxy_url"
      export no_proxy="$__proxy_no_proxy"
      export NO_PROXY="$__proxy_no_proxy"
      export HOMEBREW_ALL_PROXY="$__proxy_url"
      export HOMEBREW_NO_PROXY="$__proxy_no_proxy"
      echo "✓ Proxy enabled ($__proxy_url)"
      ;;
  esac
}

# 默认开启代理
proxy
