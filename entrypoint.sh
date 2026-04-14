#!/bin/bash
set -e

NODE_URL="${1}"
AMOUNT="${2}"
WALLET_FROM="${3}"
ADMIN_KEY="${4}"
RECIPIENT="${5:-}"
MEMO="${6:-PR merged — RTC reward}"
PR_AUTHOR="${GITHUB_ACTOR:-unknown}"
PAYLOAD="${7:-}"

# Use PR author as recipient if not specified
if [ -z "$RECIPIENT" ]; then
  RECIPIENT="$PR_AUTHOR"
fi

echo "Awarding ${AMOUNT} RTC to ${RECIPIENT} on merge of ${GITHUB_REPOSITORY}#${PR_NUMBER}"
echo "Node: ${NODE_URL}"

python3 /app/src/reward.py \
  --node-url "$NODE_URL" \
  --amount "$AMOUNT" \
  --wallet-from "$WALLET_FROM" \
  --admin-key "$ADMIN_KEY" \
  --recipient "$RECIPIENT" \
  --memo "$MEMO"
