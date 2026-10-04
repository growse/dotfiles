#!/bin/bash
# Injects the Grafana service account token from the OS keyring before exec'ing the MCP server.
# Secret stored via: secret-tool store service claude-mcp server grafana key service_account_token
set -euo pipefail

export GRAFANA_SERVICE_ACCOUNT_TOKEN
GRAFANA_SERVICE_ACCOUNT_TOKEN="$(secret-tool lookup service claude-mcp server grafana key service_account_token)"

exec uvx mcp-grafana
