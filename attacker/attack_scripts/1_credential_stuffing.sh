#!/bin/sh
TARGET="${BASE_URL}/signin"
TOKEN="fixed_malicious_token_123"

for i in $(seq 1 30); do
  curl -X POST "$TARGET" \
    -H "Authorization: Bearer $TOKEN" \
    -d "username=user$i&password=badpassword" &
done
wait
