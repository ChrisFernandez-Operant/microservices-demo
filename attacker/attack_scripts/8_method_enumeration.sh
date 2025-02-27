#!/bin/bash
TOKEN="fixed_malicious_token_321"
ENDPOINT="${BASE_URL}/multi_method"

for method in GET POST PUT DELETE PATCH; do
  curl -X $method "$ENDPOINT" \
    -H "Authorization: Bearer $TOKEN"
done
