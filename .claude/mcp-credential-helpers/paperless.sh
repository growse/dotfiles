#!/bin/bash
# Injects the paperless-ngx API key from the OS keyring before exec'ing the MCP server.
# Secret stored via: secret-tool store service claude-mcp server paperless key api_key
set -euo pipefail

export API_KEY
API_KEY="$(secret-tool lookup service claude-mcp server paperless key api_key)"

exec npx @kjanat/paperless-mcp
