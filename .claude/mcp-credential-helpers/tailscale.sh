#!/bin/bash
# Injects the Tailscale API key from the OS keyring before exec'ing the MCP server.
# Secret stored via: secret-tool store service claude-mcp server tailscale key api_key
set -euo pipefail

export TAILSCALE_API_KEY
TAILSCALE_API_KEY="$(secret-tool lookup service claude-mcp server tailscale key api_key)"

exec npx --yes --package=@hexsleeves/tailscale-mcp-server@1.3.4 tailscale-mcp-server
