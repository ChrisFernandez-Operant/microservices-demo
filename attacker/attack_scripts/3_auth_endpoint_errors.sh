#!/bin/bash
ENDPOINTS=("signin" "signup" "auth" "authenticate")
TOKEN="fixed_malicious_token_789"

for endpoint in "${ENDPOINTS[@]}"; do
  for i in $(seq 1 10); do
    curl -X POST "${BASE_URL}/${endpoint}" \
      -H "Authorization: Bearer $TOKEN" \
      -d "username=user$i&password=wrong" &
  done
done
wait
