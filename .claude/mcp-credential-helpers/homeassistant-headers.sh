#!/bin/bash
# headersHelper for the homeassistant MCP server: prints connection headers as JSON.
# Secret stored via: secret-tool store service claude-mcp server homeassistant key bearer_token
set -euo pipefail

token="$(secret-tool lookup service claude-mcp server homeassistant key bearer_token)"
printf '{"Authorization":"Bearer %s"}\n' "$token"
