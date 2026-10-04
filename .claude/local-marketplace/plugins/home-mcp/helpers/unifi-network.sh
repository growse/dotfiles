#!/bin/bash
# Injects the UniFi controller's local admin credentials from the OS keyring before exec'ing the MCP server.
# Secrets stored via:
#   secret-tool store service claude-mcp server unifi-network key username
#   secret-tool store service claude-mcp server unifi-network key password
set -euo pipefail

export UNIFI_NETWORK_USERNAME UNIFI_NETWORK_PASSWORD
UNIFI_NETWORK_USERNAME="$(secret-tool lookup service claude-mcp server unifi-network key username)"
UNIFI_NETWORK_PASSWORD="$(secret-tool lookup service claude-mcp server unifi-network key password)"

exec uvx --python-preference system unifi-network-mcp==0.21.1
