#!/bin/bash
# Wrapper for AgentMail API calls - reads key from the correct source
# The key never appears in prompts, logs, or this file.
#
# Key resolution order:
#   1. $HSE_HOME/.api_key        (dedicated key file, chmod 600)
#   2. $AGENTMAIL_API_KEY env var
#
# Usage: agentmail-curl.sh <method> <path> [data]
#   path starting with 'mcp:' is routed to the MCP JSON-RPC bridge
set -e

: "${HSE_HOME:=$HOME/.hermes/hse}"

KEY=$(cat "$HSE_HOME/.api_key" 2>/dev/null | tr -d '\n' | tr -d '\r' | head -c 255)

if [ -z "$KEY" ]; then
    KEY="$AGENTMAIL_API_KEY"
fi

if [ -z "$KEY" ]; then
    echo "ERROR: AgentMail key not found. Write it to \$HSE_HOME/.api_key or export AGENTMAIL_API_KEY." >&2
    exit 1
fi

METHOD="${1:-GET}"
PATH_ARG="${2:-/inboxes}"
DATA="${3:-}"

BASE="https://api.agentmail.to"
MCP_BASE="https://mcp.agentmail.to"

case "$PATH_ARG" in
mcp:*)
    # MCP JSON-RPC call - strip 'mcp:' prefix
    BODY="${PATH_ARG#mcp:}"
    curl -s -X POST "$MCP_BASE/mcp" \
      -H "Authorization: Bearer $KEY" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json, text/event-stream" \
      -d "$BODY"
    ;;
*)
    # REST API call
    if [ -n "$DATA" ]; then
        curl -s -X "$METHOD" "$BASE$PATH_ARG" \
          -H "Authorization: Bearer $KEY" \
          -H "Content-Type: application/json" \
          -d "$DATA"
    else
        curl -s -X "$METHOD" "$BASE$PATH_ARG" \
          -H "Authorization: Bearer $KEY" \
          -H "Accept: application/json"
    fi
    ;;
esac
