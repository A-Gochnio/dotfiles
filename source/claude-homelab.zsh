#!/bin/zsh
# claude-local – a convenience wrapper for the local Claude CLI
claude-local() {
  ANTHROPIC_BASE_URL=http://llm.dom:11434 \
  ANTHROPIC_AUTH_TOKEN=ollama \
  ANTHROPIC_API_KEY="" \
  ANTHROPIC_DEFAULT_OPUS_MODEL=gpt-oss:20b \
  ANTHROPIC_DEFAULT_SONNET_MODEL=gpt-oss:20b \
  ANTHROPIC_DEFAULT_HAIKU_MODEL=gpt-oss:20b \
  CLAUDE_CODE_ATTRIBUTION_HEADER=0 \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  CLAUDE_CONFIG_DIR="$HOME/.claude-local" \
  API_TIMEOUT_MS=3600000 \
  claude --model gpt-oss:20b --permission-mode default --disallowedTools Agent "$@"
}
